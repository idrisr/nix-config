{ config
, lib
, modulesPath
, inputs
, ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    inputs.nixos-hardware.nixosModules.framework-11th-gen-intel
    (import ./disko-framework.nix { device = "/dev/nvme0n1"; })
  ];

  boot = {
    initrd = {
      availableKernelModules = [ "xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod" ];
      kernelModules = [ "zfs" ];
      supportedFilesystems = [ "zfs" ];
    };
    kernelModules = [ "kvm-intel" "zfs" ];
    extraModulePackages = [ ];
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    binfmt.emulatedSystems = [ "aarch64-linux" ];
    zfs.requestEncryptionCredentials = [ "home/home" ];
  };

  fileSystems."/" = {
    device = "rpool/root";
    fsType = "zfs";
  };

  fileSystems."/nix" = {
    device = "rpool/nix";
    fsType = "zfs";
  };

  fileSystems."/home" = {
    device = "home/home";
    fsType = "zfs";
  };

  services = {
    fwupd.enable = true;
    autorandr.enable = true;
  };

  networking = {
    useDHCP = lib.mkDefault true;
    hostName = "framework";
    networkmanager.enable = true;
    firewall.allowedTCPPorts = [ 631 6969 2234 1143 1025 ];
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
}
