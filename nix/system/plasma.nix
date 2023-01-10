{ config, lib, pkgs, ... }:

{
  services = {
    xserver = {
      desktopManager.plasma5.enable = true;
      windowManager.xmonad.enable = true;
      displayManager.sddm.enable = true;
      enable = true;
      layout = "us";
      xkbOptions = "caps:escape";
      xkbVariant = "";
    };
  };
}
