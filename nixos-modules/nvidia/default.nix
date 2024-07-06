{ config, lib, pkgs, ... }:
with lib;
let cfg = config.nvidia-gpu;
in {
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

    nixpkgs = {
      config.allowUnfreePredicate = pkg:
        builtins.elem (lib.getName pkg) [
          "cuda-merged-12.2"
          "cuda-merged"
          "nvidia-x11"
          "nvidia-settings"
          "nvidia-persistenced"
          "nvtop-nvidia"
          "cudatoolkit-12.2.2"
          # "cudatoolkit-12.2"
          "cudaPackages.cudatoolkit"
        ];
      config.allowUnfree = true;

    };
    environment.systemPackages = with pkgs; [ nvtopPackages.nvidia ];

    # Enable OpenGL
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
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
