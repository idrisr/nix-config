{ config, lib, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot = {
    initrd = {
      availableKernelModules =
        [ "xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod" ];
      kernelModules = [ ];
      network = {
        enable = true;
        ssh = {
          enable = true;
          authorizedKeys = [
            (builtins.readFile
              ../../nixos-modules/public-keys/id_ed25519-framework.pub)
          ];
          hostKeys = [ "/etc/initrd/ssh_host_ed25519_key" ];
        };
      };

      luks.devices."cryptroot" = {
        device = "/dev/disk/by-partlabel/cryptroot";
        allowDiscards = true;
        preLVM = true;
      };
    };

    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    extraModulePackages = [ ];
    kernelModules = [ "kvm-intel" ];
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/863596cd-ec36-4e79-9a89-9595d68747b5";
      fsType = "ext4";
    };

    "boot" = {
      device = "/dev/disk/by-uuid/1779-5439";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };
  };

  boot.initrd.luks.devices."myvol".device =
    "/dev/disk/by-uuid/f7a80f51-db6e-4b3b-85c8-f6fc4f45a14c";

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.tailscale0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp170s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode =
    lib.mkDefault config.hardware.enableRedistributableFirmware;
  system.stateVersion = "25.11"; # Did you read the comment?
}
