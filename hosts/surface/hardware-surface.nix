{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    ../../nixos-modules/power
    inputs.nixos-hardware.nixosModules.microsoft-surface-pro-intel
    (import ./disko-surface.nix { device = "/dev/nvme0n1"; })
  ];
  config = {
    boot = {
      loader = {
        grub = {
          enable = true;
          efiSupport = true;
          devices = [ "nodev" ];
          extraConfig = ''
            GRUB_GFXMODE=2880x1920
            GRUB_GFXPAYLOAD_LINUX=keep
          '';
        };
        systemd-boot.enable = false;
        efi.canTouchEfiVariables = true;
      };
      initrd = {
        availableKernelModules = [
          "surface_aggregator_hub"
          "surface_aggregator_registry"
          "8250_dw"
          "intel_lpss"
          "intel_lpss_pci"
        ];
        kernelModules = [ ];
      };
      kernelModules = [ "kvm-intel" ];
      extraModulePackages = [ ];
      kernelParams = [
        # "intel_iommu=on"
        "i915.enable_rc6=1"
        "i915.enable_psr=0"
        "systemd.unified_cgroup_hierarchy=0"
      ];
    };

    networking = {
      hostName = "surface";
      networkmanager.enable = true;
      interfaces.wlp0s20f3.useDHCP = true;
      firewall.allowedTCPPorts = [ 6969 2234 1143 1025 ];
    };

    sound.enable = true;

    hardware = {
      pulseaudio.enable = true;
      bluetooth.enable = false;
      cpu.intel.updateMicrocode =
        lib.mkDefault config.hardware.enableRedistributableFirmware;
    };

    environment = {
      systemPackages = with pkgs; [ libimobiledevice protonmail-bridge ifuse ];

      variables = {
        QT_SCALE_FACTOR = "1";
        GDK_SCALE = "1.0";
      };
    };

    services = {
      iptsd.config.Touch.DisableOnPalm = true;
      autorandr.enable = true;
      fwupd.enable = true;
      xserver.upscaleDefaultCursor = true;
      usbmuxd = { enable = true; };
    };

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    powerManagement.enable = true;
    system.stateVersion = "24.05";
  };
}
