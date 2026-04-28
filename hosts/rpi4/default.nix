{ inputs, lib, modulesPath, ... }:
{
  imports = [
    (modulesPath + "/installer/sd-card/sd-image-aarch64.nix")
    inputs.nixos-hardware.nixosModules.raspberry-pi-4
  ];

  config = {
    my.base.enable = true;

    boot = {
      kernelParams = [
        "console=serial0,115200n8"
        "console=tty1"
      ];
      loader.systemd-boot.enable = lib.mkForce false;
      supportedFilesystems.zfs = lib.mkForce false;
    };

    hardware.enableRedistributableFirmware = true;
    hardware.graphics.enable32Bit = lib.mkForce false;

    networking = {
      hostName = "rpi4";
      networkmanager.enable = true;
      useDHCP = lib.mkDefault true;
    };

    programs.hyprland.enable = lib.mkForce false;
    programs.droidcam.enable = lib.mkForce false;
    services.openssh.enable = true;
    services.greetd.enable = lib.mkForce false;

    sdImage.compressImage = false;

    nixpkgs.hostPlatform = "aarch64-linux";
    system.stateVersion = "25.05";
  };
}
