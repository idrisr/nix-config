{ config
, lib
, pkgs
, modulesPath
, ...
}:
let
  initrdWifiInterface = "wlp0s20u1";
  initrdWifiConfigPath = "/home/hippoid/.config/nix-secrets/air-initrd-wpa_supplicant.conf";
in {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (import ./disko-air.nix { device = "/dev/sda"; })
  ];

  config = {
    boot = {
      kernelParams = [ "console=tty0" "console=ttyS0,115200n8" ];
      kernelModules = [ "8250" "8250_pnp" ];
      initrd = {
        secrets = {
          "/etc/initrd-wpa_supplicant.conf" = initrdWifiConfigPath;
        };
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
          "iwlmvm"
          "iwlwifi"
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
          "iwlmvm"
          "iwlwifi"
        ];

        systemd = {
          contents = {
            "/etc/wpa_supplicant-initrd.conf".source = pkgs.writeText "wpa_supplicant-initrd.conf" ''
              ctrl_interface=/run/wpa_supplicant
              ctrl_interface_group=0
              update_config=0
              include=/etc/initrd-wpa_supplicant.conf
            '';
          };
          extraBin = {
            wpa_supplicant = "${pkgs.wpa_supplicant}/bin/wpa_supplicant";
          };
          network = {
            enable = true;
            networks."10-initrd-dhcp" = {
              matchConfig.Name = "en*";
              networkConfig.DHCP = "yes";
              dhcpV4Config = {
                RouteMetric = 5;
              };
            };
            networks."20-initrd-wifi" = {
              matchConfig.Name = initrdWifiInterface;
              networkConfig = {
                DHCP = "yes";
                IgnoreCarrierLoss = true;
              };
              dhcpV4Config = {
                RouteMetric = 10;
              };
            };
            wait-online.anyInterface = true;
          };

          services.initrd-wpa-supplicant = {
            wantedBy = [ "initrd.target" ];
            after = [
              "systemd-udevd.service"
              "systemd-modules-load.service"
            ];
            before = [
              "systemd-networkd.service"
              "systemd-networkd-wait-online.service"
            ];
            serviceConfig = {
              Type = "simple";
              Restart = "always";
              RestartSec = "2s";
              ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p /run/wpa_supplicant";
              ExecStart = "${pkgs.wpa_supplicant}/bin/wpa_supplicant -i${initrdWifiInterface} -c/etc/wpa_supplicant-initrd.conf";
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
    systemd.services."serial-getty@ttyS0".enable = true;
    environment.systemPackages = [ pkgs.lm_sensors ];
    hardware.enableRedistributableFirmware = lib.mkDefault true;

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
