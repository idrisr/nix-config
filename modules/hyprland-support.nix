{ config, lib, pkgs, ... }:
let
  cfg = config.my.hyprland-support;
in
{
  options.my.hyprland-support.enable = lib.mkEnableOption "Hyprland support";

  config = lib.mkIf cfg.enable {
    # required services and drivers
    services.xserver.enable = false;
    services.xserver.displayManager.startx.enable = false;
    fonts.fontconfig.enable = true;

    # wayland session support
    environment.sessionVariables = {
      WLR_NO_HARDWARE_CURSORS = "1";
      XDG_SESSION_TYPE = "wayland";
    };

    # mesa / vulkan support
    hardware = {
      graphics = {
        enable32Bit = false;
        enable = true;
      };
    };

    # wayland extras
    programs.hyprland = {
      enable = true;
      withUWSM = true;
      xwayland.enable = true;
    };

    programs.niri.enable = true;

    environment.sessionVariables.NIXOS_OZONE_WL = "1";

    environment.systemPackages = with pkgs; [
      xdg-utils
      glib # for gsettings schemas
      kitty
      tuigreet
    ];

    services.greetd = {
      enable = true;
      useTextGreeter = false;
      settings = {
        default_session = {
          command = "start-hyprland";
          user = "hippoid";
        };
      };
    };
  };
}
