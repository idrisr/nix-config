{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ./borg/borgrepo.nix
    ./adguard.nix
  ];

  boot = {
    initrd = {
      availableKernelModules =
        [ "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
      kernelModules = [ ];
    };
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernelModules = [ "kvm-intel" "wl" ];
    extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];
  };

  services.logind.lidSwitch = "ignore";

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/e7d0549d-a683-42b7-ae71-86f4b1f50037";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/B3B0-2B43";
    fsType = "vfat";
  };

  swapDevices =
    [{ device = "/dev/disk/by-uuid/9e0d2205-844e-43d3-9c63-730138cc6db4"; }];

  networking = {
    networkmanager.enable = true;
    hostName = "air";
    useDHCP = lib.mkDefault true;
  };

  nixpkgs = {
    hostPlatform = lib.mkDefault "x86_64-linux";
    config.allowUnfreePredicate = p:
      builtins.elem (pkgs.lib.getName p) [ "broadcom-sta" ];
  };

  hardware.cpu.intel.updateMicrocode =
    lib.mkDefault config.hardware.enableRedistributableFirmware;
  system.stateVersion = "23.11";
}
