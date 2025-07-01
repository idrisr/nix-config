{ pkgs, ... }:

{
  # required services and drivers
  services.xserver.enable = true;
  services.xserver.displayManager.startx.enable = true;

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
  programs.hyprland.enable = true;

  environment.systemPackages = with pkgs; [
    xdg-utils
    glib # for gsettings schemas
    hyprland
  ];
}
