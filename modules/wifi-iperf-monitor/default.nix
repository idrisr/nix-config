{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.my.wifi-iperf-monitor;
  runWifiIperfMonitor = pkgs.writeShellApplication {
    name = "wifi-iperf-monitor-runner";
    runtimeInputs = with pkgs; [
      coreutils
      curl
      hostname
      iperf3
      iputils
      jq
      python3
      util-linux
    ];
    text = ''
      set -euo pipefail

      exec 9>/run/wifi-iperf-monitor.lock
      if ! flock -n 9; then
        echo "wifi-iperf-monitor is already running, skipping overlap" >&2
        exit 0
      fi

      instance="$(hostname -s)"
      server_host="${cfg.serverHost}"
      push_url="${lib.removeSuffix "/" cfg.pushgatewayUrl}/metrics/job/wifi_iperf/instance/$instance"

      escape_label() {
        local value="$1"
        value="''${value//\\/\\\\}"
        value="''${value//\"/\\\"}"
        value="''${value//$'\n'/ }"
        printf '%s' "$value"
      }

      upload_json="$(mktemp)"
      download_json="$(mktemp)"
      trap 'rm -f "$upload_json" "$download_json"' EXIT

      success=1

      if ! iperf3 \
        --client "$server_host" \
        --json \
        --parallel ${toString cfg.parallelStreams} \
        --time ${toString cfg.testDurationSeconds} \
        --omit ${toString cfg.omitSeconds} \
        >"$upload_json"
      then
        echo "iperf3 upload test failed" >&2
        success=0
      fi

      if ! iperf3 \
        --client "$server_host" \
        --reverse \
        --json \
        --parallel ${toString cfg.parallelStreams} \
        --time ${toString cfg.testDurationSeconds} \
        --omit ${toString cfg.omitSeconds} \
        >"$download_json"
      then
        echo "iperf3 download test failed" >&2
        success=0
      fi

      upload_bps=""
      download_bps=""

      if [ "$success" -eq 1 ]; then
        upload_bps="$(jq -er '.end.sum_sent.bits_per_second // .end.sum.bits_per_second' "$upload_json" 2>/dev/null || true)"
        download_bps="$(jq -er '.end.sum_received.bits_per_second // .end.sum.bits_per_second' "$download_json" 2>/dev/null || true)"

        if [ -z "$upload_bps" ] || [ -z "$download_bps" ]; then
          echo "failed to parse iperf3 JSON output" >&2
          success=0
        fi
      fi

      ${optionalString cfg.enablePing ''
        ping_avg_ms=""
        ping_target="${if cfg.pingHost == null then cfg.serverHost else cfg.pingHost}"
        ping_output="$(ping -n -c ${toString cfg.pingCount} -W ${toString cfg.pingTimeoutSeconds} "$ping_target" || true)"
        if [ -n "$ping_output" ]; then
          ping_avg_ms="$(python3 -c 'import re, sys; text = sys.stdin.read(); match = re.search(r"=\\s*[0-9.]+/([0-9.]+)/", text); print(match.group(1) if match else "")' <<<"$ping_output")"
        fi
      ''}

      server_label="$(escape_label "$server_host")"

      {
        printf 'wifi_iperf_success %s\n' "$success"

        if [ "$success" -eq 1 ]; then
          printf 'wifi_upload_bps{server="%s"} %s\n' "$server_label" "$upload_bps"
          printf 'wifi_download_bps{server="%s"} %s\n' "$server_label" "$download_bps"
        fi

        ${optionalString cfg.enablePing ''
          if [ -n "''${ping_avg_ms:-}" ]; then
            ping_target_label="$(escape_label "$ping_target")"
            printf 'wifi_latency_ms{target="%s"} %s\n' "$ping_target_label" "$ping_avg_ms"
          fi
        ''}
      } | curl --fail --show-error --silent --data-binary @- "$push_url"

      echo "pushed Wi-Fi iperf metrics to pushgateway" >&2
    '';
  };
in
{
  options = {
    my.wifi-iperf-monitor = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc "Enable periodic Wi-Fi throughput monitoring with iperf3.";
      };

      serverHost = mkOption {
        type = types.str;
        default = "";
        example = "192.168.8.231";
        description = lib.mdDoc "IP address or hostname of the wired iperf3 server.";
      };

      pushgatewayUrl = mkOption {
        type = types.str;
        default = "http://192.168.8.231:9091";
        example = "http://godel:9091";
        description = lib.mdDoc "Prometheus Pushgateway base URL used to push metrics.";
      };

      testDurationSeconds = mkOption {
        type = types.ints.positive;
        default = 20;
        description = lib.mdDoc "Duration of each iperf3 run in seconds.";
      };

      parallelStreams = mkOption {
        type = types.ints.positive;
        default = 4;
        description = lib.mdDoc "Number of parallel iperf3 streams per test run.";
      };

      omitSeconds = mkOption {
        type = types.ints.unsigned;
        default = 3;
        description = lib.mdDoc "Seconds to omit at the start of each iperf3 test run.";
      };

      onBootSec = mkOption {
        type = types.str;
        default = "5m";
        description = lib.mdDoc "Delay after boot before first test run.";
      };

      interval = mkOption {
        type = types.str;
        default = "10m";
        description = lib.mdDoc "Time between completed test runs.";
      };

      randomizedDelaySec = mkOption {
        type = types.str;
        default = "45s";
        description = lib.mdDoc "Randomized timer delay to avoid synchronized bursts.";
      };

      enablePing = mkOption {
        type = types.bool;
        default = true;
        description = lib.mdDoc "Collect optional ping latency metric alongside throughput.";
      };

      pingHost = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = lib.mdDoc "Ping target for wifi_latency_ms; defaults to serverHost when null.";
      };

      pingCount = mkOption {
        type = types.ints.positive;
        default = 4;
        description = lib.mdDoc "Number of ICMP probes to send per run.";
      };

      pingTimeoutSeconds = mkOption {
        type = types.ints.positive;
        default = 3;
        description = lib.mdDoc "Per-probe timeout for ping in seconds.";
      };
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.serverHost != "";
        message = "my.wifi-iperf-monitor.serverHost must be set when monitoring is enabled.";
      }
    ];

    systemd.services.wifi-iperf-monitor = {
      description = "Run periodic Wi-Fi iperf3 checks and push metrics";
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = lib.getExe runWifiIperfMonitor;
      };
    };

    systemd.timers.wifi-iperf-monitor = {
      description = "Run Wi-Fi throughput checks every 10 minutes";
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnBootSec = cfg.onBootSec;
        OnUnitActiveSec = cfg.interval;
        Persistent = true;
        RandomizedDelaySec = cfg.randomizedDelaySec;
        Unit = "wifi-iperf-monitor.service";
      };
    };
  };
}
