{ pkgs, ... }: {
  imports = [ ./hardware-framework.nix ];
  config = {
    my.base.enable = true;
    my.opnsenseBackup.enable = true;
    my.pinchflat.enable = true;
    my.pipewire.enable = true;
    my.pipewire.airpods.enable = true;
    my.pipewire.airpods.deviceName = "bluez_card.58_0A_D4_EB_A7_4B";
    my.vikunja.enable = true;
    my.printer.enable = true;
    my.clientnode.enable = true;
    borg-backup-client.enable = true;
    virtualization.enable = true;
    services.blueman.enable = true;
    hardware.bluetooth.enable = true;
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
      # variables = { QT_SCALE_FACTOR = "0.75"; };
    };
    # profile = {
    # dailydrive.enable = true;
    # rofi-book-search.enable = true;
    # };
  };
}
