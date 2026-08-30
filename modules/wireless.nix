{ config, lib, pkgs, ... }:
let
  cfg = config.my.wireless;
in
{
  options.my.wireless.enable = lib.mkEnableOption "wireless networking support";

  config = lib.mkIf cfg.enable {
    networking = {
      wireless.iwd.enable = true;
      networkmanager.wifi.backend = "iwd";
    };

    environment.systemPackages = with pkgs; [
      impala
    ];
  };
}
