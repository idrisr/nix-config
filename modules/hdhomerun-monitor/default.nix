{ config
, lib
, pkgs
, ...
}:
with lib;
let
  cfg = config.my.hdhomerun-monitor;
  runHdhomerunMetrics = pkgs.writeShellApplication {
    name = "hdhomerun-metrics-exporter";
    runtimeInputs = with pkgs; [
      coreutils
      curl
      gnugrep
      libhdhomerun
      jq
      gnused
    ];
    text = ''
      set -euo pipefail

      device_ip="${cfg.deviceIp}"
      test_channel='${if cfg.testChannel == null then "" else cfg.testChannel}'
      test_rf_channel='${if cfg.testRfChannel == null then "" else cfg.testRfChannel}'
      test_program='${if cfg.testProgram == null then "" else toString cfg.testProgram}'
      test_tuner="tuner${toString cfg.testTuner}"
      test_lockkey="${cfg.lockKey}"
      settle_delay='${toString cfg.settleDelaySec}'
      tmp_file="$(mktemp)"
      final_file="${cfg.textfileDirectory}/${cfg.metricFileName}"

      cleanup() {
        rm -f "$tmp_file"
      }
      trap cleanup EXIT

      tuner_count="$(curl --fail --silent "http://$device_ip/discover.json" | jq -r '.TunerCount // 0')"
      lineup_json="$(curl --fail --silent "http://$device_ip/lineup.json")"

      if [ -n "$test_rf_channel" ]; then
        hdhomerun_config "$device_ip" set "/$test_tuner/lockkey" none >/dev/null || true
        hdhomerun_config "$device_ip" set "/$test_tuner/lockkey" "$test_lockkey" >/dev/null || true
        hdhomerun_config "$device_ip" set "/$test_tuner/channel" none >/dev/null || true
        hdhomerun_config "$device_ip" set "/$test_tuner/channel" "$test_rf_channel" >/dev/null || true
        if [ -n "$test_program" ]; then
          hdhomerun_config "$device_ip" set "/$test_tuner/program" "$test_program" >/dev/null || true
        fi
        sleep "$settle_delay"
      elif [ -n "$test_channel" ]; then
        hdhomerun_config "$device_ip" set "/$test_tuner/lockkey" none >/dev/null || true
        hdhomerun_config "$device_ip" set "/$test_tuner/lockkey" "$test_lockkey" >/dev/null || true
        hdhomerun_config "$device_ip" set "/$test_tuner/channel" none >/dev/null || true
        hdhomerun_config "$device_ip" set "/$test_tuner/vchannel" "$test_channel" >/dev/null || true
        sleep "$settle_delay"
      fi

      {
        printf '# HELP hdhomerun_up HDHomeRun scrape success.\n'
        printf '# TYPE hdhomerun_up gauge\n'
        printf 'hdhomerun_up{device="%s"} 1\n' "$device_ip"
        printf '# HELP hdhomerun_tuner_locked Whether the tuner currently reports a lock.\n'
        printf '# TYPE hdhomerun_tuner_locked gauge\n'
        printf '# HELP hdhomerun_signal_strength_pct Reported signal strength percentage.\n'
        printf '# TYPE hdhomerun_signal_strength_pct gauge\n'
        printf '# HELP hdhomerun_signal_quality_pct Reported signal quality percentage.\n'
        printf '# TYPE hdhomerun_signal_quality_pct gauge\n'
        printf '# HELP hdhomerun_symbol_quality_pct Reported symbol quality percentage.\n'
        printf '# TYPE hdhomerun_symbol_quality_pct gauge\n'
        printf '# HELP hdhomerun_stream_bps Reported stream rate in bits per second.\n'
        printf '# TYPE hdhomerun_stream_bps gauge\n'
        printf '# HELP hdhomerun_raw_bps Reported raw rate in packets per second from tuner status.\n'
        printf '# TYPE hdhomerun_raw_bps gauge\n'
        printf '# HELP hdhomerun_channel_virtual_info Channel info for currently tuned program.\n'
        printf '# TYPE hdhomerun_channel_virtual_info gauge\n'
      } > "$tmp_file"

      i=0
      while [ "$i" -lt "$tuner_count" ]; do
        tuner="tuner$i"
        status="$(hdhomerun_config "$device_ip" get "/$tuner/status" 2>/dev/null || true)"
        vchannel="$(hdhomerun_config "$device_ip" get "/$tuner/vchannel" 2>/dev/null || true)"
        channel="$(hdhomerun_config "$device_ip" get "/$tuner/channel" 2>/dev/null || true)"

        lock_value="$(printf '%s\n' "$status" | grep -o 'lock=[^ ]*' | head -n1 | cut -d= -f2 || true)"
        ss_value="$(printf '%s\n' "$status" | grep -o 'ss=[0-9]*' | head -n1 | cut -d= -f2 || true)"
        snq_value="$(printf '%s\n' "$status" | grep -o 'snq=[0-9]*' | head -n1 | cut -d= -f2 || true)"
        seq_value="$(printf '%s\n' "$status" | grep -o 'seq=[0-9]*' | head -n1 | cut -d= -f2 || true)"
        bps_value="$(printf '%s\n' "$status" | grep -o 'bps=[0-9]*' | head -n1 | cut -d= -f2 || true)"
        pps_value="$(printf '%s\n' "$status" | grep -o 'pps=[0-9]*' | head -n1 | cut -d= -f2 || true)"

        locked=0
        if [ -n "$lock_value" ] && [ "$lock_value" != "none" ]; then
          locked=1
        fi

        guide_name=""
        if [ -n "$vchannel" ] && [ "$vchannel" != "none" ]; then
          guide_name="$(printf '%s' "$lineup_json" | jq -r --arg channel "$vchannel" '.[] | select(.GuideNumber == $channel) | .GuideName' | head -n1)"
        fi

        guide_name_escaped="$(printf '%s' "$guide_name" | sed 's/\\/\\\\/g; s/"/\\"/g')"
        vchannel_escaped="$(printf '%s' "$vchannel" | sed 's/\\/\\\\/g; s/"/\\"/g')"
        channel_escaped="$(printf '%s' "$channel" | sed 's/\\/\\\\/g; s/"/\\"/g')"
        lock_escaped="$(printf '%s' "$lock_value" | sed 's/\\/\\\\/g; s/"/\\"/g')"

        {
          printf 'hdhomerun_tuner_locked{device="%s",tuner="%s",lock="%s",channel="%s",vchannel="%s",guide_name="%s"} %s\n' "$device_ip" "$tuner" "$lock_escaped" "$channel_escaped" "$vchannel_escaped" "$guide_name_escaped" "$locked"
          printf 'hdhomerun_signal_strength_pct{device="%s",tuner="%s",lock="%s",channel="%s",vchannel="%s",guide_name="%s"} %s\n' "$device_ip" "$tuner" "$lock_escaped" "$channel_escaped" "$vchannel_escaped" "$guide_name_escaped" "''${ss_value:-0}"
          printf 'hdhomerun_signal_quality_pct{device="%s",tuner="%s",lock="%s",channel="%s",vchannel="%s",guide_name="%s"} %s\n' "$device_ip" "$tuner" "$lock_escaped" "$channel_escaped" "$vchannel_escaped" "$guide_name_escaped" "''${snq_value:-0}"
          printf 'hdhomerun_symbol_quality_pct{device="%s",tuner="%s",lock="%s",channel="%s",vchannel="%s",guide_name="%s"} %s\n' "$device_ip" "$tuner" "$lock_escaped" "$channel_escaped" "$vchannel_escaped" "$guide_name_escaped" "''${seq_value:-0}"
          printf 'hdhomerun_stream_bps{device="%s",tuner="%s",lock="%s",channel="%s",vchannel="%s",guide_name="%s"} %s\n' "$device_ip" "$tuner" "$lock_escaped" "$channel_escaped" "$vchannel_escaped" "$guide_name_escaped" "''${bps_value:-0}"
          printf 'hdhomerun_raw_bps{device="%s",tuner="%s",lock="%s",channel="%s",vchannel="%s",guide_name="%s"} %s\n' "$device_ip" "$tuner" "$lock_escaped" "$channel_escaped" "$vchannel_escaped" "$guide_name_escaped" "''${pps_value:-0}"
          printf 'hdhomerun_channel_virtual_info{device="%s",tuner="%s",channel="%s",vchannel="%s",guide_name="%s"} 1\n' "$device_ip" "$tuner" "$channel_escaped" "$vchannel_escaped" "$guide_name_escaped"
        } >> "$tmp_file"

        i=$((i + 1))
      done

      install -D -m 0644 "$tmp_file" "$final_file"
    '';
  };
in
{
  options.my.hdhomerun-monitor = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc "Enable HDHomeRun signal metric collection and dashboard provisioning.";
    };

    deviceIp = mkOption {
      type = types.str;
      default = "192.168.8.103";
      example = "192.168.8.103";
      description = lib.mdDoc "IP address of the HDHomeRun device to poll.";
    };

    textfileDirectory = mkOption {
      type = types.str;
      default = "/var/lib/prometheus-node-exporter-textfiles";
      description = lib.mdDoc "Directory used by the node exporter textfile collector for generated HDHomeRun metrics.";
    };

    metricFileName = mkOption {
      type = types.str;
      default = "hdhomerun.prom";
      description = lib.mdDoc "Metric filename written into the node exporter textfile collector directory.";
    };

    testChannel = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "2.1";
      description = lib.mdDoc "Optional virtual channel to actively tune during each sampling run.";
    };

    testRfChannel = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "auto:19";
      description = lib.mdDoc "Optional RF channel specification used for active tuning, for example auto:19 or auto:503000000.";
    };

    testProgram = mkOption {
      type = types.nullOr types.int;
      default = null;
      example = 2;
      description = lib.mdDoc "Optional MPEG program number used after tuning testRfChannel.";
    };

    testTuner = mkOption {
      type = types.int;
      default = 0;
      description = lib.mdDoc "Tuner index used for active test tuning when testChannel is set.";
    };

    settleDelaySec = mkOption {
      type = types.ints.unsigned;
      default = 4;
      description = lib.mdDoc "Seconds to wait after actively tuning a test channel before sampling status.";
    };

    lockKey = mkOption {
      type = types.str;
      default = "42424242";
      description = lib.mdDoc "HDHomeRun lockkey used to claim the test tuner before active tuning.";
    };

    onBootSec = mkOption {
      type = types.str;
      default = "30s";
      description = lib.mdDoc "Delay after boot before the first HDHomeRun metrics collection run.";
    };

    interval = mkOption {
      type = types.str;
      default = "15s";
      description = lib.mdDoc "Time between HDHomeRun metric collection runs.";
    };

    dashboardUid = mkOption {
      type = types.str;
      default = "hdhomerun-antenna";
      description = lib.mdDoc "UID used by the provisioned Grafana dashboard.";
    };

    dashboardTitle = mkOption {
      type = types.str;
      default = "HDHomeRun Antenna Placement";
      description = lib.mdDoc "Title shown in Grafana for the provisioned dashboard.";
    };

    scrapeTarget = mkOption {
      type = types.str;
      default = "127.0.0.1:9100";
      description = lib.mdDoc "Prometheus scrape target that exposes the HDHomeRun textfile metrics via node exporter.";
    };

    prometheusJobName = mkOption {
      type = types.strMatching "[A-Za-z0-9_:.-]+";
      default = "hdhomerun-node-exporter";
      description = lib.mdDoc "Prometheus job name used to scrape HDHomeRun metrics through node exporter.";
    };
  };

  config = mkIf cfg.enable {
    services.prometheus.exporters.node = {
      enable = true;
      enabledCollectors = [ "textfile" ];
      disabledCollectors = mkForce [ ];
      extraFlags = [ "--collector.textfile.directory=${cfg.textfileDirectory}" ];
    };

    systemd.tmpfiles.rules = [
      "d ${cfg.textfileDirectory} 0755 prometheus prometheus -"
    ];

    systemd.services.hdhomerun-metrics = {
      description = "Collect HDHomeRun metrics for Prometheus";
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = lib.getExe runHdhomerunMetrics;
        User = "prometheus";
        Group = "prometheus";
      };
    };

    systemd.timers.hdhomerun-metrics = {
      description = "Run HDHomeRun metrics collection on a schedule";
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnBootSec = cfg.onBootSec;
        OnUnitActiveSec = cfg.interval;
        Persistent = true;
        Unit = "hdhomerun-metrics.service";
      };
    };

    services.prometheus.scrapeConfigs = [
      {
        job_name = cfg.prometheusJobName;
        static_configs = [
          {
            targets = [ cfg.scrapeTarget ];
            labels = {
              service = "hdhomerun";
            };
          }
        ];
      }
    ];
  };
}
