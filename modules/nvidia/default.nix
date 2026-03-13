{ config
, lib
, pkgs
, ...
}:
with lib; let
  cfg = config.nvidia-gpu;
in
{
  options = {
    nvidia-gpu = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = lib.mdDoc ''
          Enable nvidia-gpu.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    hardware.nvidia.package =
      config.boot.kernelPackages.nvidiaPackages.production; # (installs 550)

    services.prometheus.exporters.nvidia-gpu = {
      enable = true;
      openFirewall = true;
    };

    environment.systemPackages = with pkgs; [
      nvtopPackages.nvidia
      # prometheus-dcgm-exporter
      dcgm
    ];

    # Enable OpenGL
    hardware.graphics = {
      enable = true;
    };

    # Load nvidia driver for Xorg and Wayland
    services.xserver.videoDrivers = [ "nvidia" ];

    hardware.nvidia = {
      modesetting.enable = true;
      powerManagement.enable = false;
      powerManagement.finegrained = false;
      open = false;
      nvidiaSettings = true;
    };
  };
}
