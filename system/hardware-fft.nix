{ config, lib, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ./adguard.nix
    ./borgrepo.nix
    ./superdrive.nix
  ];

  config = {
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.initrd.availableKernelModules =
      [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
    boot.initrd.kernelModules = [ "dm-snapshot" ];
    boot.kernelModules = [ "kvm-amd" ];
    boot.extraModulePackages = [ ];

    fileSystems."/boot" = { options = [ "umask=0077" ]; };

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
