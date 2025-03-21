{ config, lib, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix") ./disko-fft.nix ];

  config = {
    boot = {
      loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
      };
      initrd = {
        availableKernelModules =
          [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
        kernelModules = [ "dm-snapshot" ];
      };
      kernelModules = [ "kvm-amd" ];
      extraModulePackages = [ ];
    };

    fileSystems."/boot" = { options = [ "umask=0077" ]; };
    monitoring.enable = true;

    services = {
      openssh = {
        settings.X11Forwarding = true;
        allowSFTP = true;
      };
      pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
      };
    };

    networking = {
      useDHCP = lib.mkDefault true;
      interfaces.enp5s0.useDHCP = lib.mkDefault true;
      hostName = "fft";
      networkmanager.enable = false;
      adblocker.enable = true;
    };

    nixpkgs = { hostPlatform = lib.mkDefault "x86_64-linux"; };
    hardware = {
      superdrive.enable = true;
      cpu.amd.updateMicrocode =
        lib.mkDefault config.hardware.enableRedistributableFirmware;
    };
    system.stateVersion = "23.11";
  };
}
