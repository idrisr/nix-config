{ config, lib, pkgs, ... }:
let
  cfg = config.my.trackpad;
in
{
  options.my.trackpad.enable = lib.mkEnableOption "trackpad support";

  config = lib.mkIf cfg.enable {
    services.libinput = {
      enable = true;
      touchpad.clickMethod = "clickfinger";
    };

    environment.systemPackages = with pkgs; [
      libinput
      wev
    ];
  };
}
