{ config, pkgs, lib, ... }:

{
  imports = [ ];
  options = { };

  config = {
    # microsoft-surface.ipts.enable = true;
    systemd.services.iptsd = lib.mkForce { };

    boot = {
      # https://rbf.dev/blog/2020/05/custom-nixos-build-for-raspberry-pis/
      binfmt.emulatedSystems = [ "aarch64-linux" ];

      initrd.availableKernelModules =
        [ "xhci_pci" "thunderbolt" "nvme" "usb_storage" "usbhid" "sd_mod" ];
      initrd.kernelModules = [ ];
      kernelModules = [ "nbd" "kvm-intel" ];
      extraModulePackages = [ ];
      loader.systemd-boot.enable = true;
      loader.efi.canTouchEfiVariables = true;
      loader.efi.efiSysMountPoint = "/boot/efi";
      kernelParams = [
        "intel_iommu=on"
        "i915.enable_rc6=1"
        "i915.enable_psr=0"
        "systemd.unified_cgroup_hierarchy=0"
      ];
    };

    networking = {
      hostName = "surface";
      networkmanager.enable = true;
      interfaces.wlp0s20f3.useDHCP = true;
      firewall.allowedTCPPorts = [ 6969 ];
    };

    fileSystems = {
      "/" = {
        device = "/dev/disk/by-uuid/ffba5bd6-bff9-4af1-9f30-172a1fe2d303";
        fsType = "ext4";
      };

      "/boot/efi" = {
        device = "/dev/disk/by-uuid/1AFB-3F6E";
        fsType = "vfat";
      };
    };

    sound.enable = true;

    hardware = {
      pulseaudio.enable = false;
      bluetooth.enable = true;
      cpu.intel.updateMicrocode =
        lib.mkDefault config.hardware.enableRedistributableFirmware;
    };

    environment = {
      systemPackages = with pkgs; [
        tasks
        screen-config
        libimobiledevice
        ifuse
      ];
    };

    services = {
      usbmuxd = { enable = true; };

      tarsnap = {
        enable = true;
        keyfile = "/home/hippoid/dotfiles/tarsnap/keyfile";
        archives = {
          roam = {
            directories = [ "/home/hippoid/roam-export" ];
            period = "daily";
            cachedir = "/home/hippoid/cache";
          };
        };
      };

      printing.enable = true;
    };

    swapDevices =
      [{ device = "/dev/disk/by-uuid/0622a2b4-f555-484f-bbcf-b2c026f111e1"; }];

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    powerManagement.enable = false;
  };
}
