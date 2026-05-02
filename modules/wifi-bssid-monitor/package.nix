{
  cfg,
  lib,
  pkgs,
  writeShellApplication,
}:
let
  parser = pkgs.callPackage ./parser-package.nix { };
  dwellSeconds =
    let
      wholeSeconds = builtins.div cfg.dwellMs 1000;
      fractionalMs = cfg.dwellMs - (wholeSeconds * 1000);
    in
    "${toString wholeSeconds}.${lib.fixedWidthString 3 "0" (toString fractionalMs)}";
in
writeShellApplication {
  name = "wifi-bssid-monitor-runner";
  runtimeInputs = [
    pkgs.coreutils
    pkgs.curl
    pkgs.gnugrep
    pkgs.hostname
    pkgs.iproute2
    pkgs.iw
    parser
    pkgs.tshark
    pkgs.util-linux
  ];
  text = ''
    set -euo pipefail

    exec 9>/run/wifi-bssid-monitor.lock
    if ! flock -n 9; then
      echo "wifi-bssid-monitor is already running, skipping overlap" >&2
      exit 0
    fi

    instance="$(hostname -s)"
    push_url="${lib.removeSuffix "/" cfg.pushgatewayUrl}/metrics/job/${cfg.jobName}/instance/$instance"
    base_iface="${cfg.interface}"
    monitor_iface="${cfg.monitorInterface}"
    dwell_seconds="${dwellSeconds}"

    sample_tsv="$(mktemp)"
    metrics_file="$(mktemp)"
    state_dir="/var/lib/wifi-bssid-monitor"
    state_file="$state_dir/ssid-map.json"
    cleanup_needed=0
    base_was_up=0
    channel_count=0
    started_at="$(date +%s.%N)"

    cleanup() {
      set +e
      if [ "$cleanup_needed" -eq 1 ]; then
        ip link set "$monitor_iface" down >/dev/null 2>&1 || true
        iw dev "$monitor_iface" del >/dev/null 2>&1 || true
      fi

      if [ "$base_was_up" -eq 1 ]; then
        ip link set "$base_iface" up >/dev/null 2>&1 || true
      fi

      rm -f "$sample_tsv" "$metrics_file"
    }
    trap cleanup EXIT

    mkdir -p "$state_dir"

    if ip link show "$monitor_iface" >/dev/null 2>&1; then
      echo "monitor interface $monitor_iface already exists" >&2
      exit 1
    fi

    if ip link show "$base_iface" >/dev/null 2>&1; then
      if ip link show "$base_iface" | grep -q "state UP"; then
        base_was_up=1
      fi
    else
      echo "base interface $base_iface does not exist" >&2
      exit 1
    fi

    ip link set "$base_iface" down
    iw dev "$base_iface" interface add "$monitor_iface" type monitor
    cleanup_needed=1
    ip link set "$monitor_iface" up

    collect_channel() {
      local band="$1"
      local channel="$2"

      echo "sampling $band channel $channel" >&2
      iw dev "$monitor_iface" set channel "$channel"

      tshark \
        -Q \
        -n \
        -l \
        -i "$monitor_iface" \
        -a "duration:$dwell_seconds" \
        -Y 'wlan.bssid && (wlan.fc.type == 0 || wlan.fc.type == 2)' \
        -T fields \
        -E header=n \
        -E separator=$'\t' \
        -e wlan.bssid \
        -e radiotap.dbm_antsignal \
        -e wlan.ssid \
        2>/dev/null \
        | wifi-bssid-monitor-parser append \
          --output "$sample_tsv" \
          --band "$band" \
          --channel "$channel"

      channel_count=$((channel_count + 1))
    }

    ${pkgs.lib.concatMapStringsSep "\n" (
      channel: "collect_channel 2g ${toString channel}"
    ) cfg.channels2g}
    ${pkgs.lib.concatMapStringsSep "\n" (
      channel: "collect_channel 5g ${toString channel}"
    ) cfg.channels5g}

    ended_at="$(date +%s.%N)"

    wifi-bssid-monitor-parser render \
      --sample "$sample_tsv" \
      --output "$metrics_file" \
      --instance "$instance" \
      --dwell-seconds "$dwell_seconds" \
      --started-at "$started_at" \
      --ended-at "$ended_at" \
      --channel-count "$channel_count" \
      --min-signal-dbm "${toString cfg.minSignalDbm}" \
      --state-file "$state_file"

    curl \
      --fail \
      --show-error \
      --silent \
      --request PUT \
      --data-binary @"$metrics_file" \
      "$push_url"

    echo "pushed Wi-Fi BSSID metrics to pushgateway" >&2
  '';
}
