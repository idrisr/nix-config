{ config, lib, pkgs, modulesPath, ... }: {
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];
  options = { };

  config = {
    boot = {
      initrd = {
        availableKernelModules =
          [ "xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod" ];
        kernelModules = [ ];
        luks.devices."luks-460133ac-96c0-464a-a541-68d77cb28d93".device =
          "/dev/disk/by-uuid/460133ac-96c0-464a-a541-68d77cb28d93";
      };

      kernelModules = [ "kvm-intel" ];
      extraModulePackages = [ ];
    };

    fileSystems."/" = {
      device = "/dev/disk/by-uuid/8a8db973-3a22-4ace-ac07-b44f247b9c06";
      fsType = "ext4";
    };

    fileSystems."/boot/efi" = {
      device = "/dev/disk/by-uuid/BE4C-FC21";
      fsType = "vfat";
    };

    swapDevices = [ ];

    # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
    # (the default) this is the recommended approach. When using systemd-networkd it's
    # still possible to use this option, but it's recommended to use it in conjunction
    # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
    networking.useDHCP = lib.mkDefault true;
    # networking.interfaces.wlp170s0.useDHCP = lib.mkDefault true;

    powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
    hardware.cpu.intel.updateMicrocode =
      lib.mkDefault config.hardware.enableRedistributableFirmware;
    # high-resolution display
    hardware.video.hidpi.enable = lib.mkDefault true;
  };
  system.stateVersion = "22.05";
}
