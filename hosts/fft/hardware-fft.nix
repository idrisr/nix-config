{ config, lib, modulesPath, inputs, ... }:

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

    sound = {
      enable = true;
      extraConfig = ''
        defaults.pcm.card 1
        defaults.ctl.card 1
      '';
    };

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

    nixpkgs = {
      hostPlatform = lib.mkDefault "x86_64-linux";
      overlays = [ inputs.zettel.overlays.zettel ];
    };
    hardware = {
      superdrive.enable = true;
      cpu.amd.updateMicrocode =
        lib.mkDefault config.hardware.enableRedistributableFirmware;
    };
    system.stateVersion = "23.11";
  };
}
