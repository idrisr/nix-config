{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  config = {
    base.enable = true;
    unifi.enable = true;
    users.users.root = {
      hashedPassword =
        "$y$j9T$BowmS9BT0LZ5WNT1V4Day1$dae0REqJAJuNehr7b3Uj3Zy.dToJ30mwOqugbA39b02";
    };

    boot = {
      initrd = {
        availableKernelModules =
          [ "xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod" "igc" ];
        network = {
          enable = true;
          flushBeforeStage2 = true;

          ssh = {
            enable = true;
            authorizedKeys = [
              (builtins.readFile
                ../../nixos-modules/public-keys/id_ed25519-framework.pub)
            ];
            hostKeys = [ "/etc/secrets/initrd/ssh_host_ed25519_key" ];
          };

          postCommands = "";
        };

        systemd = {
          enable = true;
          extraBin = {
            systemd-tty-ask-password-agent =
              "${pkgs.systemd}/bin/systemd-tty-ask-password-agent";
            ip = "${pkgs.iproute2}/bin/ip";
          };

          services."unlock-agent" = {
            wantedBy = [ "initrd.target" ];
            serviceConfig = {
              StandardOutput = "journal";

              ExecStart =
                "${pkgs.systemd}/bin/systemd-tty-ask-password-agent --watch --no-tty";

              StandardError = "journal";
            };
          };
        };
        luks.devices."myvol" = {
          device = "/dev/disk/by-uuid/1004a810-9d15-4e13-b82e-e6cb48f4fd8b";
        };
      };

      loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
      };
    };

    fileSystems = {
      "/" = {
        device = "/dev/disk/by-uuid/c21ec255-a3f9-4915-8492-7f7b1dc2876b";
        fsType = "ext4";
      };

      "/boot" = {
        device = "/dev/disk/by-uuid/2010-27F2";
        fsType = "vfat";
        options = [ "fmask=0077" "dmask=0077" ];
      };
    };

    networking = {
      useDHCP = true;
      hostName = "godel";
    };

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    hardware.cpu.intel.updateMicrocode =
      lib.mkDefault config.hardware.enableRedistributableFirmware;
    system.stateVersion = "25.11"; # Did you read the comment?
  };
}
