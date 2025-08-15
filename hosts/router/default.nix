{ pkgs, ... }:
let
  wanMAC = "00:e0:67:30:ae:a6";
  lanMAC = "00:e0:67:30:ae:a7";
in
{
  nix.settings.require-sigs = false;

  boot.loader.systemd-boot.enable = false;
  boot = {
    kernelParams =
      [ "console=ttyS0,115200" "console=tty1" "video=HDMI-A-1:1024x600@60" ];
    initrd.kernelModules = [ "virtio_console" ];
    loader = {
      grub = {
        enable = true;
        device = "/dev/sda";
        extraConfig = ''
          set timeout=5
          set timeout_style=menu
        '';
      };
    };
  };

  networking = {
    usePredictableInterfaceNames = false;
    interfaces.wan.useDHCP = true;
    hostName = "router";

    interfaces.lan.ipv4.addresses = [{
      address = "192.168.1.1";
      prefixLength = 24;
    }];

    nat = {
      enable = true;
      externalInterface = "wan";
      internalInterfaces = [ "lan" ];
    };

    firewall = {
      enable = true;
      allowedTCPPorts = [ 22 ];
    };
  };

  nix = {
    package = pkgs.nixVersions.stable;

    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      trusted-users = [ "root" ];
      auto-optimise-store = true;
    };

    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 7d";
    };
  };

  services.kea.dhcp4 = {
    enable = true;
    settings = {
      interfaces-config = { interfaces = [ "lan" ]; };
      subnet4 = [{
        id = 1;
        subnet = "192.168.1.0/24";
        pools = [{ pool = "192.168.1.100 - 192.168.1.200"; }];
        option-data = [{
          name = "routers";
          data = "192.168.1.1";
        }];
      }];
    };
  };

  environment.systemPackages = with pkgs; [ sysz ];
  services.openssh.enable = true;

  users.users.root.openssh.authorizedKeys.keys =
    [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINsnWJFXUmPQeaDEAmN7Dwyulu2WAiNTd1FesWJFfyi/ hippoid@framework" ];

  users.users.root.initialHashedPassword = "";
  system.stateVersion = "24.05";

  services.udev.extraRules = ''
    SUBSYSTEM=="net", ACTION=="add", ATTR{address}=="${wanMAC}", NAME="wan"
    SUBSYSTEM=="net", ACTION=="add", ATTR{address}=="${lanMAC}", NAME="lan"
  '';
}
