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

    fileSystems."/" = {
      device = "/dev/disk/by-uuid/b5b5d2cd-824f-4004-ac7c-74457c4e8c38";
      fsType = "ext4";
    };

    fileSystems."/boot" = {
      device = "/dev/disk/by-uuid/8E55-2EA9";
      fsType = "vfat";
    };

    swapDevices =
      [{ device = "/dev/disk/by-uuid/6555459a-5de8-459d-8f67-76630ff0c91c"; }];

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
      printing.enable = true;
    };

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    powerManagement.enable = false;
  };
}
