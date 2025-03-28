{ config, pkgs, lib, inputs, ... }: {
  imports = [
    ../../nixos-modules/power
    inputs.nixos-hardware.nixosModules.microsoft-surface-pro-intel
    (import ./disko-surface.nix { device = "/dev/nvme0n1"; })
  ];
  config = {
    boot = {
      kernelPatches = [{
        name = "intel-ipu6";
        patch = ./0016-intel-ipu6.patch;
      }];
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
      ];
    };
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };

    systemd.services = {
      bluetooth.serviceConfig.ExecStart = [
        ""
        "${pkgs.bluez}/libexec/bluetooth/bluetoothd --noplugin=sap,avrcp"
      ];
      NetworkManager-wait-online.enable = lib.mkForce false;
      systemd-networkd-wait-online.enable = lib.mkForce false;
    };

    networking = {
      hostName = "surface";
      wireless.iwd.enable = false;
      networkmanager = { enable = true; };
      interfaces.wlp0s20f3.useDHCP = true;
      firewall.allowedTCPPorts = [ 631 6969 2234 1143 1025 5000 ];
    };
    hardware = {
      pulseaudio.enable = false;
      bluetooth = {
        settings = { General = { ControllerMode = "bredr"; }; };
        enable = true;
      };
      cpu.intel.updateMicrocode =
        lib.mkDefault config.hardware.enableRedistributableFirmware;
    };

    environment = {
      systemPackages = with pkgs; [
        libimobiledevice
        protonmail-bridge-gui
        protonmail-bridge
        ifuse
      ];

      variables = {
        QT_SCALE_FACTOR = "1";
        GDK_SCALE = "1.0";
      };
    };

    hardware.alsa.enablePersistence = true;

    services = {
      iptsd.config.Touchscreen.DisableOnPalm = true;
      autorandr.enable = true;
      fwupd.enable = false;
      xserver.upscaleDefaultCursor = true;
      usbmuxd = { enable = true; };
    };

    powerManagement.enable = true;
    system.stateVersion = "24.05";
  };
}

# 58:0A:D4:EB:A7:4B Idris’s Airpods - Find My
