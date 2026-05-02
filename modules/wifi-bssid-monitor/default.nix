{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.my.wifi-bssid-monitor;
  runWifiBssidMonitor = pkgs.callPackage ./package.nix { inherit cfg lib; };
in
{
  options.my.wifi-bssid-monitor = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc "Enable periodic Wi-Fi BSSID sampling and Prometheus export.";
    };

    interface = mkOption {
      type = types.str;
      default = "";
      example = "wlp8s0";
      description = lib.mdDoc "Base Wi-Fi interface used to create a temporary monitor interface.";
    };

    monitorInterface = mkOption {
      type = types.str;
      default = "wifimon0";
      description = lib.mdDoc "Temporary monitor-mode interface name created during each sampling run.";
    };

    pushgatewayUrl = mkOption {
      type = types.str;
      default = "http://192.168.8.224:9091";
      example = "http://godel:9091";
      description = lib.mdDoc "Prometheus Pushgateway base URL used to publish sampled Wi-Fi metrics.";
    };

    jobName = mkOption {
      type = types.strMatching "[A-Za-z0-9_:.-]+";
      default = "wifi_bssid";
      description = lib.mdDoc "Pushgateway job name used when publishing Wi-Fi BSSID metrics.";
    };

    channels2g = mkOption {
      type = types.listOf types.ints.positive;
      default = lib.range 1 13;
      description = lib.mdDoc "2.4 GHz channels to sample on each run.";
    };

    channels5g = mkOption {
      type = types.listOf types.ints.positive;
      default = [
        36
        40
        44
        48
        52
        56
        60
        64
        100
        104
        108
        112
        116
        120
        124
        128
        132
        136
        140
        144
        149
        153
        157
        161
        165
      ];
      description = lib.mdDoc "5 GHz channels to sample on each run.";
    };

    dwellMs = mkOption {
      type = types.ints.positive;
      default = 500;
      description = lib.mdDoc "Per-channel sampling dwell time in milliseconds.";
    };

    minSignalDbm = mkOption {
      type = types.number;
      default = -75;
      example = -70;
      description = lib.mdDoc "Minimum RSSI (dBm) required to include frames in metrics.";
    };

    onBootSec = mkOption {
      type = types.str;
      default = "2m";
      description = lib.mdDoc "Delay after boot before the first sampling run.";
    };

    interval = mkOption {
      type = types.str;
      default = "5m";
      description = lib.mdDoc "Time between completed Wi-Fi sampling runs.";
    };

    randomizedDelaySec = mkOption {
      type = types.str;
      default = "30s";
      description = lib.mdDoc "Randomized timer delay to avoid synchronized collection runs.";
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.interface != "";
        message = "my.wifi-bssid-monitor.interface must be set when monitoring is enabled.";
      }
      {
        assertion = cfg.monitorInterface != cfg.interface;
        message = "my.wifi-bssid-monitor.monitorInterface must differ from my.wifi-bssid-monitor.interface.";
      }
      {
        assertion = cfg.channels2g != [ ] || cfg.channels5g != [ ];
        message = "my.wifi-bssid-monitor must have at least one configured channel to sample.";
      }
      {
        assertion = cfg.minSignalDbm <= 0;
        message = "my.wifi-bssid-monitor.minSignalDbm must be <= 0 dBm.";
      }
    ];

    systemd.services.wifi-bssid-monitor = {
      description = "Sample Wi-Fi BSSIDs and push Prometheus metrics";
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = lib.getExe runWifiBssidMonitor;
      };
    };

    systemd.timers.wifi-bssid-monitor = {
      description = "Run Wi-Fi BSSID monitor on a schedule";
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnBootSec = cfg.onBootSec;
        OnUnitActiveSec = cfg.interval;
        Persistent = true;
        RandomizedDelaySec = cfg.randomizedDelaySec;
        Unit = "wifi-bssid-monitor.service";
      };
    };
  };
}
