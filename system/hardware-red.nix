{ config, lib, pkgs, modulesPath, ... }: {

  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];
  boot = {
    initrd = {
      availableKernelModules =
        [ "uhci_hcd" "ehci_pci" "ahci" "usb_storage" "sd_mod" ];
      kernelModules = [ ];
    };

    kernelModules = [ "wl" ];
    extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];

    loader.grub = {
      enable = true;
      device = "/dev/sda"; # or "nodev" for efi only
    };
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/4e4105ee-4d9b-4dbf-a782-a9d4b91a6195";
    fsType = "ext4";
  };

  swapDevices =
    [{ device = "/dev/disk/by-uuid/f166becf-7e9e-4c64-be72-4c655329f318"; }];

  networking = {
    hostName = "red";
    useDHCP = lib.mkDefault true;
    networkmanager.enable = true;
  };

  nixpkgs.hostPlatform = lib.mkDefault "i686-linux";
  hardware.cpu.intel.updateMicrocode =
    lib.mkDefault config.hardware.enableRedistributableFirmware;
  system.stateVersion = "22.11"; # Did you read the comment? no.
  nixpkgs.config.allowUnfree = true;

  services = { logind.lidSwitch = "ignore"; };
}
