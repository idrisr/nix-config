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
  "luks-edef38c3-d8f8-444d-9e96-fedfbde573bc".device = "/dev/disk/by-uuid/edef38c3-d8f8-444d-9e96-fedfbde573bc";
      };
    };
    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/65140436-aea1-4525-90a6-000dd8284bdb";
      fsType = "ext4";
    };


  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/F971-583B";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };


  services.fwupd.enable = true;
  sound.enable = true;
  swapDevices =
    [ { device = "/dev/disk/by-uuid/a2670414-e2e1-4ba6-8fa0-416df590d006"; }
    ];

  networking = {
    useDHCP = lib.mkDefault true;
    hostName = "framework";
    networkmanager.enable = true;
  };

  system.stateVersion = "23.05"; # Did you read the comment? no.
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode =
    lib.mkDefault config.hardware.enableRedistributableFirmware;
}
