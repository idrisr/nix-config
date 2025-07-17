{ pkgs, ... }:

{
  # required services and drivers
  services.xserver.enable = true;
  services.xserver.displayManager.startx.enable = true;
  fonts.fontconfig.enable = true;

  # wayland session support
  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    XDG_SESSION_TYPE = "wayland";
  };

  # input (optional)
  services.libinput.enable = true;

  # mesa / vulkan support
  hardware = {
    graphics = {
      enable32Bit = true;
      enable = true;
    };
  };

  # wayland extras
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };

  environment.systemPackages = with pkgs; [
    xdg-utils
    glib # for gsettings schemas
    hyprland
    kitty
    greetd.tuigreet
  ];

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "Hyprland";
        user = "hippoid";
      };

      initial_session = {
        command = "tuigreet --cmd Hyprland";
        user = "greeter";
      };
    };
  };
}
