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
      initrd = {
        availableKernelModules = [ "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" "wl" ];
        kernelModules = [ "coretemp" "applesmc" ];

        # MacBook Air 6,2 (Model A1466, 2013, Intel i5-4250U)
        # Boot from USB: hold Option at chime.
        # Kernel tested: 6.12.31.
        # Internal Wi-Fi chipset: Broadcom BCM4360 (PCI ID 14e4:43a0).
        # In-kernel driver: brcmfmac supports BCM4360 (see LKDDb: https://cateee.net/lkddb/).
        # Community reports: https://linux-hardware.org/?view=search&vendor=Apple&model=MacBookAir6%2C2
        # External USB Wi-Fi: AR9271 (Atheros) uses in-kernel ath9k_htc.

        network = {
          enable = true;
          ssh = {
            enable = true;
            authorizedKeys = [
              (builtins.readFile
                ../../modules/public-keys/id_ed25519-framework.pub)
            ];
            hostKeys = [ "/etc/secrets/initrd/ssh_host_ed25519_key" ];
            shell = "/bin/cryptsetup-askpass";
          };
        };
      };

      loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
      };
      extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];
    };

    services.logind.settings.Login.HandleLidSwitch = "ignore";
    environment.systemPackages = [ pkgs.lm_sensors ];

    networking = {
      networkmanager.enable = true;
      hostName = "air";
      useDHCP = lib.mkDefault true;
      adblocker.enable = true;
    };

    nixpkgs = {
      hostPlatform = lib.mkDefault "x86_64-linux";
      config.allowUnfreePredicate = p:
        builtins.elem (pkgs.lib.getName p) [ "broadcom-sta" ];
      config.permittedInsecurePackages = [
        "broadcom-sta-6.30.223.271-59-6.12.68"
      ];
    };

    hardware.cpu.intel.updateMicrocode =
      lib.mkDefault config.hardware.enableRedistributableFirmware;
    system.stateVersion = "23.11";
  };
}
