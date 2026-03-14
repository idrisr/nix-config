{ config
, lib
, modulesPath
, ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ./disko-fft.nix
  ];

  config = {
    boot = {
      kernelParams = [ "console=ttyS0,115200" "console=tty1" ];
      loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
      };
      initrd = {
        availableKernelModules = [
          "nvme"
          "xhci_pci"
          "ahci"
          "usbhid"
          "usb_storage"
          "sd_mod"
        ];
        kernelModules = [ "dm-snapshot" "igc" "e1000e" "r8169" ];
        systemd.network = {
          enable = true;
          networks."10-initrd-dhcp" = {
            matchConfig.Name = "en*";
            networkConfig.DHCP = "yes";
            dhcpV4Config.RouteMetric = 5;
          };
        };
      };
      kernelModules = [ "kvm-amd" ];
      extraModulePackages = [ ];
    };

    fileSystems."/boot" = { options = [ "umask=0077" ]; };

    swapDevices = [
      { device = "/swapfile"; size = 32 * 1024; } # 32GB
    ];

    services = {
      openssh = {
        settings.X11Forwarding = false;
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
      hostName = "fft";
      networkmanager.enable = false;
    };

    nixpkgs = { hostPlatform = lib.mkDefault "x86_64-linux"; };
    hardware = {
      superdrive.enable = false;
      cpu.amd.updateMicrocode =
        lib.mkDefault config.hardware.enableRedistributableFirmware;
    };
    system.stateVersion = "23.11";
  };
}
