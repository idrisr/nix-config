{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (import ./disko-air.nix { device = "/dev/sda"; })
  ];

  config = {
    boot = {
      initrd = {
        availableKernelModules =
          [ "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
        kernelModules = [ "coretemp" "applesmc" ];
      };
      loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
      };
      kernelModules = [ "kvm-intel" "wl" ];
      extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];
    };

    services.logind.lidSwitch = "ignore";
    environment.systemPackages = [ pkgs.lm_sensors ];

    networking = {
      networkmanager.enable = true;
      hostName = "air";
      useDHCP = lib.mkDefault true;
      adblocker.enable = true;
    };

    nixpkgs = {
      hostPlatform = lib.mkDefault "x86_64-linux";
      config.allowUnfreePredicate = p:
        builtins.elem (pkgs.lib.getName p) [ "broadcom-sta" ];
    };

    hardware.cpu.intel.updateMicrocode =
      lib.mkDefault config.hardware.enableRedistributableFirmware;
    system.stateVersion = "23.11";
  };
}
