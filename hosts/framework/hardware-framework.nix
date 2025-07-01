{ config, lib, modulesPath, inputs, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    inputs.nixos-hardware.nixosModules.framework-11th-gen-intel
  ];

  boot = {
    initrd = {
      availableKernelModules =
        [ "xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod" ];
      kernelModules = [ ];
      luks.devices = {
        "luks-edef38c3-d8f8-444d-9e96-fedfbde573bc".device =
          "/dev/disk/by-uuid/edef38c3-d8f8-444d-9e96-fedfbde573bc";
        # uuid block device
      };
    };
    kernelModules = [ "kvm-intel" "zfs" ];
    extraModulePackages = [ ];
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    binfmt.emulatedSystems = [ "aarch64-linux" ];
    supportedFilesystems = [ "zfs" ];

  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/65140436-aea1-4525-90a6-000dd8284bdb";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/F971-583B";
    fsType = "vfat";
    options = [ "fmask=0077" "dmask=0077" ];
  };

  services = {
    fwupd.enable = true;
    autorandr.enable = true;
  };

  networking = {
    useDHCP = lib.mkDefault true;
    hostName = "framework";
    networkmanager.enable = true;
    firewall.allowedTCPPorts = [ 631 6969 2234 1143 1025 5000 ];
    hostId = "bb825510";
  };

  security.pam.services = { };

  system.stateVersion = "23.05"; # Did you read the comment? no.
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  services.thermald.enable = true;

  powerManagement = {
    enable = true;
    powertop.enable = true;
    cpuFreqGovernor = lib.mkDefault "ondemand";
  };

  hardware.cpu.intel.updateMicrocode =
    lib.mkDefault config.hardware.enableRedistributableFirmware;
  hardware.opentabletdriver.enable = true;
  hardware.bluetooth.enable = false;
}
