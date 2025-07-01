{ pkgs, ... }:

{
  imports = [ ../framework/hardware-framework.nix ];
  config = {
    my.base.enable = true;
    boot.loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    networking = { firewall.enable = false; };

    users = {
      groups.hippoid = { };
      users.hippoid = {
        isNormalUser = true;
        group = "hippoid";
        extraGroups = [ "wheel" ];
      };
    };
    security.sudo.wheelNeedsPassword = false;

    environment.systemPackages = with pkgs; [ vifm brave vim git curl ];

    services = {
      openssh.enable = true;
      getty.autologinUser = "hippoid";
      displayManager.sddm.enable = true;
      desktopManager.plasma6.enable = true;
    };
  };
}
