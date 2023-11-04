{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ./adguard.nix
    ./superdrive.nix
  ];

  config = {
    boot = {
      initrd.availableKernelModules =
        [ "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" ];
      initrd.kernelModules = [ ];
      kernelModules = [ "kvm-amd" ];
      extraModulePackages = [ ];
      loader.systemd-boot.enable = true;
      loader.efi.canTouchEfiVariables = true;
      loader.efi.efiSysMountPoint = "/boot/efi";
      kernelParams = [ "amd_iommu=on" ];
    };

    fileSystems = {
      "/" = {
        device = "/dev/disk/by-uuid/6f185d6f-29f9-42ec-8eff-84a2f1688cfe";
        fsType = "ext4";
      };
      "/boot/efi" = {
        device = "/dev/disk/by-uuid/7CA7-49BD";
        fsType = "vfat";
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

    swapDevices =
      [{ device = "/dev/disk/by-uuid/3194ead2-55c3-4f41-93b7-7d476a390d0a"; }];

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
    system.stateVersion = "22.05";
  };
}
