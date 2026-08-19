{ pkgs, ... }:
let
  user = "hippoid";
in
{
  imports = [
    ../../modules/labrador.nix
    ./hardware-framework.nix
  ];
  config = {
    my = {
      base.enable = true;
      hyprland-support.enable = true;
      platformio.enable = true;
      printer.enable = true;
      opnsenseBackup.enable = true;
      nfs-client.enable = true;
      pinchflat.enable = false;
      kavita.enable = false;
      pipewire.enable = true;
      pipewire.airpods.enable = true;
      pipewire.airpods.deviceName = "bluez_card.58_0A_D4_EB_A7_4B";
      trackpad.enable = true;
      vikunja.enable = false;
      clientnode.enable = true;
      localHostOverrides = {
        enable = true;
        allHosts = true;
      };
      wifi-iperf-monitor = {
        enable = true;
        serverHost = "192.168.8.224";
        pushgatewayUrl = "http://192.168.8.224:9091";
        pingHost = "192.168.8.224";
        interval = "30m";
      };
    };
    borg-backup-client.enable = true;
    hardware.labrador.enable = true;
    virtualization.enable = true;
    services.blueman.enable = true;
    hardware.bluetooth.enable = true;
    fileSystems."/home/${user}/downloads/slskd" = {
      device = "godel:/srv/slskd";
      fsType = "nfs";
      options = [
        "nofail"
        "x-systemd.automount"
        "x-systemd.idle-timeout=10m"
      ];
    };
    fonts.packages = with pkgs; [ eb-garamond ];
    services.upower = {
      enable = true;
      usePercentageForPolicy = true;
      percentageLow = 10;
      percentageCritical = 5;
      percentageAction = 2;
    };
    xdg.portal = {
      enable = true;
      extraPortals = [
        pkgs.kdePackages.xdg-desktop-portal-kde
        pkgs.xdg-desktop-portal-gtk
      ];
    };
    boot.loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    nix.settings.max-jobs = 0;
    networking.firewall.enable = false;
    programs.noisetorch.enable = true;
    environment = {
      systemPackages = with pkgs; [
        framework-tool
        intel-gpu-tools
        brightnessctl
        fprintd
        tree
        openssl
        vifm
        git
        curl
      ];
    };
  };
}
