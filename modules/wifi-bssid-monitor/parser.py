#!/usr/bin/env python3

import argparse
import collections
import json
import os
import re
import sys


def escape_label(value: str) -> str:
    return value.replace("\\", "\\\\").replace('"', '\\"').replace("\n", " ")


def parse_signal(raw_value: str):
    values = []
    for part in raw_value.split(","):
        part = part.strip()
        if not part:
            continue
        try:
            values.append(float(part))
        except ValueError:
            pass
    if not values:
        return None
    return sum(values) / len(values)


HEX_RE = re.compile(r"^[0-9a-fA-F]+$")


def normalize_ssid(raw_value: str) -> str:
    value = raw_value.strip()
    if not value or value == "<MISSING>":
        return ""

    compact = value.replace(":", "")
    if len(compact) % 2 == 0 and HEX_RE.fullmatch(compact):
        try:
            decoded = bytes.fromhex(compact).decode("utf-8", errors="ignore")
            decoded = "".join(ch for ch in decoded if ch.isprintable()).strip()
            if decoded:
                return decoded
        except ValueError:
            pass

    return "".join(ch for ch in value if ch.isprintable()).strip()


def load_ssid_state(path: str) -> dict[str, str]:
    try:
        with open(path, encoding="utf-8") as handle:
            raw = json.load(handle)
    except (FileNotFoundError, json.JSONDecodeError, OSError):
        return {}

    if not isinstance(raw, dict):
        return {}

    state = {}
    for bssid, ssid in raw.items():
        if not isinstance(bssid, str) or not isinstance(ssid, str):
            continue
        bssid_key = bssid.strip().lower()
        ssid_value = normalize_ssid(ssid)
        if bssid_key and ssid_value:
            state[bssid_key] = ssid_value

    return state


def save_ssid_state(path: str, state: dict[str, str]) -> None:
    parent = os.path.dirname(path)
    if parent:
        os.makedirs(parent, exist_ok=True)

    temp_path = f"{path}.tmp"
    with open(temp_path, "w", encoding="utf-8") as handle:
        json.dump(state, handle, ensure_ascii=True, sort_keys=True)
        handle.write("\n")
    os.replace(temp_path, path)


def command_append(args: argparse.Namespace) -> int:
    with open(args.output, "a", encoding="utf-8") as out:
        for raw_line in sys.stdin:
            line = raw_line.rstrip("\n")
            if not line:
                continue
            fields = line.split("\t")
            if not fields:
                continue
            bssid = fields[0].strip().lower()
            if not bssid:
                continue
            signal = fields[1].strip() if len(fields) > 1 else ""
            raw_ssid = fields[2].strip() if len(fields) > 2 else ""
            ssid = normalize_ssid(raw_ssid)
            out.write(f"{args.band}\t{args.channel}\t{bssid}\t{signal}\t{ssid}\n")
    return 0


def command_render(args: argparse.Namespace) -> int:
    ssid_state = load_ssid_state(args.state_file) if args.state_file else {}
    per_bssid = collections.defaultdict(
        lambda: {"count": 0, "signal_sum": 0.0, "signal_count": 0, "ssid_counts": collections.Counter()}
    )
    visible_per_channel = collections.defaultdict(set)

    with open(args.sample, encoding="utf-8") as handle:
        for raw_line in handle:
            fields = raw_line.rstrip("\n").split("\t")
            if len(fields) < 4:
                continue
            band, channel, bssid, signal = fields[:4]
            parsed_signal = parse_signal(signal)
            if parsed_signal is None or parsed_signal < args.min_signal_dbm:
                continue
            ssid = fields[4].strip() if len(fields) > 4 else ""
            key = (band, channel, bssid)
            entry = per_bssid[key]
            entry["count"] += 1
            entry["signal_sum"] += parsed_signal
            entry["signal_count"] += 1
            if ssid:
                entry["ssid_counts"][ssid] += 1
            visible_per_channel[(band, channel)].add(bssid)

    lines = []
    instance_label = escape_label(args.instance)

    for (band, channel, bssid), entry in sorted(per_bssid.items()):
        ssid_counts = entry["ssid_counts"]
        observed_ssid = ssid_counts.most_common(1)[0][0] if ssid_counts else ""
        remembered_ssid = ssid_state.get(bssid, "")
        ssid = observed_ssid or remembered_ssid
        name = ssid if ssid else bssid
        if ssid:
            ssid_state[bssid] = ssid
        labels = (
            f'instance="{instance_label}",'
            f'bssid="{escape_label(bssid)}",'
            f'ssid="{escape_label(ssid)}",'
            f'name="{escape_label(name)}",'
            f'channel="{channel}",'
            f'band="{band}"'
        )
        lines.append(f"wifi_bssid_frame_count{{{labels}}} {entry['count']}")
        lines.append(f"wifi_bssid_present{{{labels}}} 1")
        if entry["signal_count"] > 0:
            avg_signal = entry["signal_sum"] / entry["signal_count"]
            lines.append(f"wifi_bssid_avg_signal_dbm{{{labels}}} {avg_signal:.3f}")

    for (band, channel), bssids in sorted(visible_per_channel.items()):
        labels = f'instance="{instance_label}",channel="{channel}",band="{band}"'
        lines.append(f"wifi_visible_bssids{{{labels}}} {len(bssids)}")
        lines.append(f"wifi_channel_sample_seconds{{{labels}}} {args.dwell_seconds}")

    duration = max(args.ended_at - args.started_at, 0.0)
    lines.append(f'wifi_sampler_success{{instance="{instance_label}"}} 1')
    lines.append(f'wifi_sampler_duration_seconds{{instance="{instance_label}"}} {duration:.3f}')
    lines.append(f'wifi_sampler_channels_total{{instance="{instance_label}"}} {args.channel_count}')

    with open(args.output, "w", encoding="utf-8") as handle:
        handle.write("\n".join(lines) + "\n")

    if args.state_file:
        save_ssid_state(args.state_file, ssid_state)

    return 0


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(prog="wifi-bssid-monitor-parser")
    subparsers = parser.add_subparsers(dest="command", required=True)

    append_parser = subparsers.add_parser("append")
    append_parser.add_argument("--output", required=True)
    append_parser.add_argument("--band", required=True)
    append_parser.add_argument("--channel", required=True)
    append_parser.set_defaults(func=command_append)

    render_parser = subparsers.add_parser("render")
    render_parser.add_argument("--sample", required=True)
    render_parser.add_argument("--output", required=True)
    render_parser.add_argument("--instance", required=True)
    render_parser.add_argument("--dwell-seconds", required=True)
    render_parser.add_argument("--started-at", required=True, type=float)
    render_parser.add_argument("--ended-at", required=True, type=float)
    render_parser.add_argument("--channel-count", required=True, type=int)
    render_parser.add_argument("--min-signal-dbm", required=True, type=float)
    render_parser.add_argument("--state-file", default="")
    render_parser.set_defaults(func=command_render)

    return parser


def main() -> int:
    parser = build_parser()
    args = parser.parse_args()
    return args.func(args)


if __name__ == "__main__":
    raise SystemExit(main())
