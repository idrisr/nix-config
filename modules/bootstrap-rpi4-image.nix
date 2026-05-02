{ inputs, lib, modulesPath, pkgs, ... }:
{
  imports = [
    inputs.nixos-hardware.nixosModules.raspberry-pi-4
    (modulesPath + "/installer/sd-card/sd-image-aarch64-installer.nix")
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
    hostName = "cust-bootstrap";
    networkmanager.enable = lib.mkForce false;
    useDHCP = lib.mkDefault true;
    wireless.enable = lib.mkForce false;
  };

  services.openssh = {
    enable = true;
    openFirewall = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };

  users.users.hippoid = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      (builtins.readFile ./public-keys/id_ed25519.pub)
      (builtins.readFile ./public-keys/id_ed25519-framework.pub)
    ];
  };

  security.sudo.wheelNeedsPassword = false;

  boot = {
    kernelParams = [
      "console=serial0,115200n8"
      "console=tty1"
    ];
    loader.generic-extlinux-compatible.enable = true;
    loader.systemd-boot.enable = false;
    supportedFilesystems.zfs = false;
  };

  hardware = {
    enableAllHardware = lib.mkForce false;
    enableRedistributableFirmware = true;
    firmware = [ pkgs.raspberrypiWirelessFirmware ];
    graphics.enable32Bit = lib.mkForce false;
  };

  system.stateVersion = "25.05";
}
