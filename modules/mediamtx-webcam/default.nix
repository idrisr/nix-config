{ config
, lib
, pkgs
, ...
}:
with lib;
let
  cfg = config.my.mediamtxWebcam;
  ffmpegPublishCommand = concatStringsSep " " [
    "${pkgs.ffmpeg}/bin/ffmpeg"
    "-hide_banner"
    "-loglevel warning"
    "-nostdin"
    "-f v4l2"
    "-framerate 30"
    "-i"
    (escapeShellArg cfg.videoDevice)
    "-an"
    "-c:v libx264"
    "-preset veryfast"
    "-tune zerolatency"
    "-pix_fmt yuv420p"
    "-r 30"
    "-g 30"
    "-keyint_min 30"
    "-sc_threshold 0"
    "-bf 0"
    "-rtsp_transport tcp"
    "-f rtsp"
    "rtsp://127.0.0.1:$RTSP_PORT/$MTX_PATH"
  ];
in
{
  options.my.mediamtxWebcam = {
    enable = mkOption {
      default = false;
      type = types.bool;
      description = lib.mdDoc "Enable a local webcam RTSP publisher via MediaMTX.";
    };

    openFirewall = mkOption {
      default = true;
      type = types.bool;
      description = lib.mdDoc "Open TCP/8554 for LAN RTSP access.";
    };

    videoDevice = mkOption {
      default = "/dev/video0";
      type = types.str;
      description = lib.mdDoc "V4L2 device path to publish via ffmpeg.";
    };
  };

  config = mkIf cfg.enable {
    services.mediamtx = {
      enable = true;
      allowVideoAccess = true;
      settings = {
        rtspAddress = ":8554";
        rtspTransports = [ "tcp" ];
        paths.cam = {
          source = "publisher";
          runOnInit = ffmpegPublishCommand;
          runOnInitRestart = true;
        };
      };
    };

    networking.firewall.allowedTCPPorts = optionals cfg.openFirewall [ 8554 ];
  };
}
