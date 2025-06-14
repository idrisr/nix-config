{ lib, config, pkgs, ... }:
with lib;
let cfg = config.nvr;
in {
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
    hardware.opengl = {
      enable = true;
      extraPackages = [ pkgs.intel-media-driver ]; # For Gen11+ Intel
    };

    services.frigate = {
      enable = true;
      vaapiDriver = "iHD"; # modern Intel VA-API driver

      hostname = "localhost";
      settings = {
        mqtt = {
          enabled = true;
          host = "mqtt.local";
        };
        cameras = {
          cam01 = {
            ffmpeg.inputs = [{
              path = "rtsp://idrisr:123456789@cam01.idrisr.com/stream1";
              roles = [ "detect" "record" ];
              hwaccel_args = "preset-vaapi";
            }];
          };

          cam02 = {
            ffmpeg.inputs = [{
              path = "rtsp://idrisr:123456789@cam02.idrisr.com/stream1";
              roles = [ "detect" "record" ];
              hwaccel_args = "preset-vaapi";
            }];
          };

          cam03 = {
            ffmpeg.inputs = [{
              path = "rtsp://idrisr:123456789@cam03.idrisr.com:554/stream1";
              roles = [ "detect" "record" ];
              hwaccel_args = "preset-vaapi";
            }];
          };
        };
      };
    };
  };
}
