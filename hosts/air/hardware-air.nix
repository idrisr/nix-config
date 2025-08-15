{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (import ./disko-air.nix { device = "/dev/sda"; })
  ];

  config = {
    boot = {
      initrd = {
        availableKernelModules =
          [ "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" "wl" ];
        kernelModules = [ "coretemp" "applesmc" ];

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

    services.logind.lidSwitch = "ignore";
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
    };

    hardware.cpu.intel.updateMicrocode =
      lib.mkDefault config.hardware.enableRedistributableFirmware;
    system.stateVersion = "23.11";
  };
}
