{ config
, lib
, pkgs
, modulesPath
, ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (import ./disko-air.nix { device = "/dev/sda"; })
  ];

  config = {
    boot = {
      kernelParams = [ "rd.systemd.device-timeout=0" ];

      initrd = {
        availableKernelModules = [
          "xhci_pci"
          "ahci"
          "usbhid"
          "usb_storage"
          "sd_mod"
          "r8152"
          "ax88179_178a"
          "asix"
          "cdc_ether"
          "cdc_ncm"
        ];
        kernelModules = [
          "coretemp"
          "applesmc"
          "usbnet"
          "cdc_ether"
          "cdc_ncm"
          "r8152"
          "ax88179_178a"
          "asix"
        ];

        systemd = {
          network = {
            enable = true;
            networks."10-initrd-dhcp" = {
              matchConfig.Name = "en*";
              networkConfig.DHCP = "yes";
              dhcpV4Config = {
                RouteMetric = 5;
              };
            };
          };
        };
      };

      loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
      };
    };

    services.hardware.bolt.enable = true;
    services.logind.settings.Login.HandleLidSwitch = "ignore";
    environment.systemPackages = [ pkgs.lm_sensors ];

    networking = {
      networkmanager.enable = true;
      hostName = "air";
      useDHCP = lib.mkDefault true;
    };

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

    hardware.cpu.intel.updateMicrocode =
      lib.mkDefault config.hardware.enableRedistributableFirmware;
    system.stateVersion = "23.11";
  };
}
