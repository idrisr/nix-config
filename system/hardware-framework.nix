{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules =
    [ "xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/0d550858-53bc-4366-b7f0-02dc38568964";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/8883-C013";
    fsType = "vfat";
  };

  swapDevices =
    [{ device = "/dev/disk/by-uuid/debb6cb7-89fc-47d3-b12e-649d2005861f"; }];

  networking.useDHCP = lib.mkDefault true;
  networking.hostName = "framework";
  networking.networkmanager.enable = true;

  system.stateVersion = "23.05"; # Did you read the comment? no.
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode =
    lib.mkDefault config.hardware.enableRedistributableFirmware;
}
