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

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/a22fb986-c9cf-46da-b4c2-0edb623a85a1";
      fsType = "ext4";
    };

  boot.initrd.luks.devices."luks-21f25e43-7bd2-4241-b902-4df8c47f80ab".device = "/dev/disk/by-uuid/21f25e43-7bd2-4241-b902-4df8c47f80ab";

  boot.initrd.luks.devices."luks-66c43e64-9f03-4c84-bfa7-85a266c04a41".device = "/dev/disk/by-uuid/66c43e64-9f03-4c84-bfa7-85a266c04a41";

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/DF69-F1D4";
      fsType = "vfat";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/056dde5e-4603-44c5-a47c-7a750f6cb2dd"; }
    ];

  networking.useDHCP = lib.mkDefault true;
  networking.hostName = "framework";
  networking.networkmanager.enable = true;

  system.stateVersion = "23.05"; # Did you read the comment? no.
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode =
    lib.mkDefault config.hardware.enableRedistributableFirmware;
}
