{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.my.prometheus-server;
  wanSpeedtestRules = pkgs.writeText "wan-speedtest-rules.yml" ''
    groups:
      - name: wan-speedtest
        rules:
          - alert: WanSpeedtestNoRecentRun
            expr: time() - timestamp(wan_speedtest_success{job="wan_speedtest"}) > 5400
            for: 10m
            labels:
              severity: critical
            annotations:
              summary: "WAN speedtest has not reported recently"
              description: "No WAN speedtest metric update has been seen for more than 90 minutes on {{ $labels.instance }}."

          - alert: WanSpeedtestFailures
            expr: max_over_time(wan_speedtest_success{job="wan_speedtest"}[2h]) < 1
            for: 15m
            labels:
              severity: warning
            annotations:
              summary: "WAN speedtest runner is failing"
              description: "WAN speedtest has not succeeded in the last 2 hours on {{ $labels.instance }}."

          - alert: WanDownloadLow
            expr: avg_over_time(wan_down_mbps{job="wan_speedtest"}[1h]) < 80
            for: 30m
            labels:
              severity: warning
            annotations:
              summary: "WAN download speed is degraded"
              description: "Average WAN download speed over the last hour is below 80 Mbps on {{ $labels.instance }}."

          - alert: WanLatencyHigh
            expr: avg_over_time(wan_ping_ms{job="wan_speedtest"}[2h]) > 60
            for: 15m
            labels:
              severity: warning
            annotations:
              summary: "WAN latency is elevated"
              description: "Average WAN latency over the last 2 hours is above 60 ms on {{ $labels.instance }}."

          - alert: WanPacketLossHigh
            expr: avg_over_time(packet_loss{job="wan_speedtest"}[2h]) > 1
            for: 15m
            labels:
              severity: warning
            annotations:
              summary: "WAN packet loss is elevated"
              description: "Average WAN packet loss over the last 2 hours is above 1% on {{ $labels.instance }}."
  '';
  runWanSpeedtest = pkgs.writeShellApplication {
    name = "wan-speedtest-runner";
    runtimeInputs = with pkgs; [
      coreutils
      curl
      hostname
      python3
      speedtest-rs
      util-linux
    ];
    text = ''
            set -euo pipefail

            exec 9>/run/wan-speedtest.lock
            if ! flock -n 9; then
              echo "wan-speedtest is already running, skipping overlap" >&2
              exit 0
            fi

            instance="$(hostname -s)"
            push_url="http://127.0.0.1:9091/metrics/job/wan_speedtest/instance/$instance"

            escape_label() {
              local value="$1"
              value="''${value//\\/\\\\}"
              value="''${value//\"/\\\"}"
              value="''${value//$'\n'/ }"
              printf '%s' "$value"
            }

            echo "running WAN speed test" >&2
            if ! speedtest_csv="$(speedtest-rs --csv)"; then
              echo "speedtest CLI failed" >&2
              printf 'wan_speedtest_success 0\n' \
                | curl --fail --show-error --silent --data-binary @- "$push_url"
              exit 1
            fi

            if ! parsed_line="$(python3 - "$speedtest_csv" <<'PY'
      import csv
      import sys

      row = next(csv.reader([sys.argv[1]]))

      def get_str(index, default="unknown"):
          try:
              value = row[index]
              return value if value else default
          except IndexError:
              return default

      def get_float(index):
          try:
              value = row[index]
          except IndexError:
              return 0.0
          try:
              return float(value) if value else 0.0
          except ValueError:
              return 0.0

      server_id = get_str(0)
      isp = get_str(1)
      server_name = get_str(2)
      ping_ms = get_float(5)
      down_mbps = get_float(6) / 1000000.0
      up_mbps = get_float(7) / 1000000.0

      print(f"{server_id}\t{isp}\t{server_name}\t{ping_ms}\t{down_mbps}\t{up_mbps}")
      PY
            )"; then
              echo "speedtest output parse failed" >&2
              printf 'wan_speedtest_success 0\n' \
                | curl --fail --show-error --silent --data-binary @- "$push_url"
              exit 1
            fi

            if [ -z "$parsed_line" ]; then
              echo "speedtest output was empty" >&2
              printf 'wan_speedtest_success 0\n' \
                | curl --fail --show-error --silent --data-binary @- "$push_url"
              exit 1
            fi

            IFS=$'\t' read -r server_id isp server_name ping_ms down_mbps up_mbps <<< "$parsed_line"
            packet_loss="0"

            server_name="$(escape_label "$server_name")"
            server_id="$(escape_label "$server_id")"
            isp="$(escape_label "$isp")"

            {
              printf 'wan_down_mbps{server="%s",server_id="%s",isp="%s"} %s\n' "$server_name" "$server_id" "$isp" "$down_mbps"
              printf 'wan_up_mbps{server="%s",server_id="%s",isp="%s"} %s\n' "$server_name" "$server_id" "$isp" "$up_mbps"
              printf 'wan_ping_ms{server="%s",server_id="%s",isp="%s"} %s\n' "$server_name" "$server_id" "$isp" "$ping_ms"
              printf 'packet_loss{server="%s",server_id="%s",isp="%s"} %s\n' "$server_name" "$server_id" "$isp" "$packet_loss"
              printf 'wan_speedtest_success 1\n'
            } | curl --fail --show-error --silent --data-binary @- "$push_url"

            echo "pushed WAN speed test metrics to pushgateway" >&2
    '';
  };
in {
  options = {
    my.prometheus-server = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = lib.mdDoc ''
          enable prometheus server
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    environment.etc = {
      "grafana-dashboards/node-fleet-overview.json".source =
        ./dashboards/node-fleet-overview.json;
      "grafana-dashboards/node-host-basic.json".source =
        ./dashboards/node-host-basic.json;
      "grafana-dashboards/router-overview.json".source =
        ./dashboards/router-overview.json;
      "grafana-dashboards/gpu-fft-node.json".source =
        ./dashboards/gpu-fft-node.json;
      "grafana-dashboards/laptop-batteries.json".source =
        ./dashboards/laptop-batteries.json;
      "grafana-dashboards/mac-mini-overview.json".source =
        ./dashboards/mac-mini-overview.json;
      "grafana-dashboards/frigate-overview.json".source =
        ./dashboards/frigate-overview.json;
      "grafana-dashboards/wan-speedtest.json".source =
        ./dashboards/wan-speedtest.json;
      "grafana-dashboards/wifi-bssid-monitor.json".source =
        ./dashboards/wifi-bssid-monitor.json;
      "grafana-dashboards/wifi-throughput.json".source =
        ./dashboards/wifi-throughput.json;
    };

    networking.firewall.allowedTCPPorts = [ 9091 ];

    systemd.services.wan-speedtest = {
      description = "Run WAN speed test and export metrics";
      after = [ "network-online.target" "prometheus-pushgateway.service" ];
      wants = [ "network-online.target" "prometheus-pushgateway.service" ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = lib.getExe runWanSpeedtest;
      };
    };

    systemd.timers.wan-speedtest = {
      description = "Run WAN speed test every hour";
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = "hourly";
        Persistent = true;
        RandomizedDelaySec = "45s";
        Unit = "wan-speedtest.service";
      };
    };

    services.grafana = {
      enable = true;
      provision = {
        enable = true;
        datasources.settings = {
          apiVersion = 1;
          datasources = [{
            name = "Prometheus";
            type = "prometheus";
            access = "proxy";
            url = "http://127.0.0.1:9090";
            isDefault = true;
            uid = "effpfi5egefwgf";
          }];
        };
        dashboards.settings = {
          apiVersion = 1;
          providers = [{
            name = "default";
            options.path = "/etc/grafana-dashboards";
          }];
        };
      };
      settings = {
        security.secret_key = "/etc/letsencrypt/live/idrisraja.com/privkey.pem";

        server = { http_port = 3010; };
        dashboards.default_home_dashboard_path =
          "/etc/grafana-dashboards/node-host-basic.json";
        analytics.reporting_enabled = false;
      };
    };
    services.prometheus = {
      enable = true;
      configText = builtins.replaceStrings [ "__WAN_SPEEDTEST_RULES__" ]
        [ (toString wanSpeedtestRules) ] (builtins.readFile ./prometheus.yml);
      # scrapeConfigs = [
      # {
      # job_name = "systemd";
      # static_configs = [
      # { targets = [ "127.0.0.1:9558" ]; }
      # ];
      # }

      # {
      # job_name = "framework";
      # static_configs = [
      # { targets = [ "127.0.0.1:9100" ]; }
      # ];
      # }
      # ];
    };

    services.prometheus.pushgateway = {
      enable = true;
      persistMetrics = true;
      web.listen-address = "0.0.0.0:9091";
    };
  };
}
