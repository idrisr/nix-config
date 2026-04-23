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
    users.users.frigate.extraGroups = [
      "coral"
      "video"
    ];

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

        ffmpeg.hwaccel_args = [ ];

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

        objects.track = [
          "person"
        ];

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
          fft_usb_cam = {
            friendly_name = "FFT USB Cam";
            timestamp_style = {
              position = "tr";
              format = "FFT USB Cam %m/%d/%Y %H:%M:%S";
            };
            detect = {
              width = 720;
              height = 1280;
            };
            ffmpeg = {
              hwaccel_args = [ ];
              output_args = {
                record = [
                  "-f"
                  "segment"
                  "-segment_time"
                  "10"
                  "-segment_format"
                  "mp4"
                  "-reset_timestamps"
                  "1"
                  "-strftime"
                  "1"
                  "-c:v"
                  "h264_nvenc"
                  "-preset"
                  "p5"
                  "-profile:v"
                  "main"
                  "-pix_fmt"
                  "yuv420p"
                  "-an"
                ];
                detect = [
                  "-threads"
                  "2"
                  "-f"
                  "rawvideo"
                  "-pix_fmt"
                  "yuv420p"
                  "-vf"
                  "transpose=1,fps=5,scale=720:1280"
                ];
              };
              inputs = [
                {
                  path = "/dev/v4l/by-id/usb-USB_Webcam_USB_Webcam_SN0001-video-index0";
                  input_args = [
                    "-f"
                    "v4l2"
                    "-thread_queue_size"
                    "512"
                    "-input_format"
                    "mjpeg"
                    "-framerate"
                    "10"
                    "-video_size"
                    "1280x720"
                  ];
                  roles = [
                    "detect"
                    "record"
                  ];
                }
              ];
            };
          };

        };
      };
    };
  };
}
