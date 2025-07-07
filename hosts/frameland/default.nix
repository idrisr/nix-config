{ pkgs, ... }:

{
  imports = [ ../framework/hardware-framework.nix ];
  config = {
    my.base.enable = true;
    borg-backup-client.enable = true;

    services.blueman.enable = true; # optional GUI
    hardware.bluetooth.enable = true;

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      audio.enable = true;
      jack.enable = true;
      wireplumber.enable = true; # modern session manager
    };

    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.kdePackages.xdg-desktop-portal-kde ];
    };

    boot.loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    networking.firewall.enable = false;

    programs.noisetorch.enable = true;

    users = {
      groups.hippoid = { };
      users.hippoid = {
        isNormalUser = true;
        group = "hippoid";
        extraGroups = [ "wheel" ];
      };
    };

    security.sudo.wheelNeedsPassword = false;
    environment.systemPackages = with pkgs; [ vifm vim git curl ];

    services = {
      openssh.enable = true;
      getty.autologinUser = "hippoid";
      displayManager.sddm.enable = true;
      desktopManager.plasma6.enable = true;
    };
  };
}
