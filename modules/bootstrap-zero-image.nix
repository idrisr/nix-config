{ config, inputs, lib, pkgs, ... }:
{
  imports = [
    inputs.nixos-hardware.nixosModules.raspberry-pi-3
    inputs.nixos-pi-zero-2.nixosModules.sd-image
  ];

  nixpkgs.overlays = [
    (_final: super: {
      makeModulesClosure = x: super.makeModulesClosure (x // { allowMissing = true; });
    })
  ];

  documentation.enable = false;

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    trusted-users = [
      "root"
      "hippoid"
    ];
    substituters = [
      "https://cache.nixos.org"
      "http://fft:8080/main"
    ];
    trusted-public-keys = [
      "main:H3eVhZKLNlPSStW/mVCFkngb9XlJYPoFx1aJ/plGwYg="
    ];
  };

  networking = {
    hostName = "zero-bootstrap";
    useDHCP = lib.mkDefault true;
    wireless = {
      enable = true;
      interfaces = [ "wlan0" ];
    };
  };

  services.openssh = {
    enable = true;
    openFirewall = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };

  services.timesyncd.enable = true;

  systemd.services."serial-getty@ttyAMA0" = {
    enable = true;
    wantedBy = [ "getty.target" ];
  };

  services.avahi = {
    enable = true;
    publish = {
      userServices = true;
      hinfo = true;
      enable = true;
      domain = true;
      addresses = true;
    };
  };

  users.mutableUsers = false;
  users.users.hippoid = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.zsh;
    hashedPassword = "$y$j9T$BowmS9BT0LZ5WNT1V4Day1$dae0REqJAJuNehr7b3Uj3Zy.dToJ30mwOqugbA39b02";
    openssh.authorizedKeys.keys = [
      (builtins.readFile ./public-keys/id_ed25519.pub)
      (builtins.readFile ./public-keys/id_ed25519-framework.pub)
    ];
  };

  security.sudo.wheelNeedsPassword = false;

  boot = {
    initrd.availableKernelModules = [
      "xhci_pci"
      "usbhid"
      "usb_storage"
      "usbnet"
      "cdc_ether"
      "cdc_ncm"
      "r8152"
      "ax88179_178a"
      "asix"
    ];
    kernelModules = [
      "usbnet"
      "cdc_ether"
      "cdc_ncm"
      "r8152"
      "ax88179_178a"
      "asix"
    ];
    kernelParams = [
      "console=serial0,115200n8"
      "console=tty1"
    ];
    kernel.sysctl."vm.mmap_rnd_bits" = 24;
    kernelPackages = lib.mkForce (
      pkgs.linuxPackagesFor (pkgs.callPackage "${inputs.nixos-hardware}/raspberry-pi/common/kernel.nix" { rpiVersion = 3; })
    );
    supportedFilesystems.zfs = false;
    swraid.enable = lib.mkForce false;
  };

  hardware = {
    enableRedistributableFirmware = lib.mkForce false;
    firmware = [ pkgs.raspberrypiWirelessFirmware ];
    graphics.enable32Bit = lib.mkForce false;
    i2c.enable = true;

    deviceTree = {
      enable = true;
      kernelPackage = config.boot.kernelPackages.kernel;
      filter = "*2837*";
      overlays = [
        {
          name = "enable-i2c";
          dtsFile = "${inputs.nixos-pi-zero-2}/dts/i2c.dts";
        }
        {
          name = "pwm-2chan";
          dtsFile = "${inputs.nixos-pi-zero-2}/dts/pwm.dts";
        }
        {
          name = "spi1-2cs";
          dtsFile = "${inputs.nixos-pi-zero-2}/dts/spi.dts";
        }
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    vim
    zsh
  ];

  programs.zsh.enable = true;

  system.stateVersion = "25.05";
}
