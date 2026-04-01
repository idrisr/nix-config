{ lib
, config
, pkgs
, ...
}:
with lib;
let
  cfg = config.nvr;
in
{
  options = {
    nvr = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = lib.mdDoc ''
          enable nvr.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    hardware.coral.pcie.enable = true;
    users.users.frigate.extraGroups = [ "coral" ];

    systemd.services.frigate.serviceConfig.TimeoutStopSec = "20s";

    hardware.graphics = {
      enable = true;
      extraPackages = [ pkgs.intel-media-driver ]; # For Gen11+ Intel
    };

    services.frigate = {
      enable = true;
      hostname = "localhost";
      settings = {
        mqtt = {
          enabled = true;
          host = "mqtt.local";
        };
        auth = {
          enabled = true;
          session_length = 604800;
          trusted_proxies = [ "192.168.8.0/24" ];
          failed_login_rate_limit = "3/second;30/minute;200/hour";
        };
        detectors = {
          coral0 = {
            type = "edgetpu";
            device = "pci:0";
          };
          coral1 = {
            type = "edgetpu";
            device = "pci:1";
          };
        };

        detect = {
          enabled = true;
          fps = 5;
        };

        objects.track = [ "person" "car" "dog" "cat" ];

        snapshots = {
          enabled = true;
          timestamp = true;
          bounding_box = true;
          retain.default = 14;
        };

        record = {
          enabled = true;
          events = {
            pre_capture = 5;
            post_capture = 5;
            retain.default = 14;
          };
        };

        cameras = {
          cam02 = {
            ffmpeg = {
              output_args.record = "preset-record-generic";
              inputs = [
                {
                  path = "rtsp://idrisr:12345678@192.168.30.202:554/stream1";
                  roles = [ "detect" "record" ];
                }
              ];
            };
          };

          cam01 = {
            ffmpeg = {
              output_args.record = "preset-record-generic";
              inputs = [
                {
                  path = "rtsp://idrisr:12345678@192.168.30.201:554/stream1";
                  roles = [ "detect" "record" ];
                }
              ];
            };
          };

        };
      };
    };
  };
}
