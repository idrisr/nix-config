{ inputs, lib, modulesPath, pkgs, ... }:
{
  imports = [
    inputs.nixos-hardware.nixosModules.raspberry-pi-4
  ];

  config = {
    my.base.enable = true;
    my.servernode = {
      enable = true;
    };
    my.nix-index.enable = false;
    my.nix-index.database.enable = true;

    boot = {
      kernelParams = [
        "console=serial0,115200n8"
        "console=tty1"
      ];
      kernel.sysctl."vm.mmap_rnd_bits" = 24;
      loader.generic-extlinux-compatible.enable = lib.mkDefault true;
      loader.systemd-boot.enable = lib.mkForce false;
      supportedFilesystems.zfs = lib.mkForce false;
    };

    fileSystems."/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
    };

    fileSystems."/boot/firmware" = {
      device = "/dev/disk/by-label/FIRMWARE";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };

    hardware.enableRedistributableFirmware = true;
    hardware.graphics.enable32Bit = lib.mkForce false;

    zramSwap = {
      enable = true;
      algorithm = "zstd";
      memoryPercent = 50;
    };

    networking = {
      hostName = "rpi4";
      networkmanager.enable = true;
      useDHCP = lib.mkDefault true;
    };

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      extraSpecialArgs = {
        inherit inputs;
        graphical = false;
        pkgs = pkgs;
      };
      users.hippoid = import (inputs."home-config" + "/home.nix");
    };

    services.xserver.enable = lib.mkForce false;
    programs.hyprland.enable = lib.mkForce false;
    programs.droidcam.enable = lib.mkForce false;
    services.openssh.enable = true;
    services.greetd.enable = lib.mkForce false;
    nixpkgs.hostPlatform = "aarch64-linux";
    system.stateVersion = "25.05";
  };
}
