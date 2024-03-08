{ config, lib, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ./adguard.nix
    ./superdrive.nix
    ./borgrepo.nix
  ];

  config = {
    boot = {
      initrd = {
        availableKernelModules =
          [ "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" ];
        kernelModules = [ "dm-snapshot" ];
      };
      kernelModules = [ "kvm-amd" ];
      extraModulePackages = [ ];
      loader = {
        grub = {
          enable = true;
          efiSupport = true;
          devices = [ "nodev" ];
        };
        systemd-boot.enable = false;
        efi = {
          canTouchEfiVariables = true;
          efiSysMountPoint = "/boot/efi";
        };
      };
      kernelParams = [ "amd_iommu=on" ];
    };

    sound = {
      enable = true;
      extraConfig = ''
        defaults.pcm.card 1
        defaults.ctl.card 1
      '';
    };

    services = {
      openssh = {
        allowSFTP = true;
        settings.LogLevel = "DEBUG";
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
    };

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    hardware = {
      cpu.amd.updateMicrocode =
        lib.mkDefault config.hardware.enableRedistributableFirmware;
    };
    system.stateVersion = "22.11";
  };
}
