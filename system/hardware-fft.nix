{ config, lib, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ./adguard.nix
    ./borgrepo.nix
    ./superdrive.nix
  ];

  config = {
    boot = {
      initrd = {
        availableKernelModules =
          [ "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" ];
      };
      kernelModules = [ "kvm-amd" ];
      loader = {
        grub = {
          enable = true;
          devices = [ "nodev" ];
        };
      };
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
    system.stateVersion = "23.11";
  };
}
