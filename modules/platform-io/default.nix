{ lib, config, pkgs, ... }:
with lib;
let
  cfg = config.my.platformio;
in
{
  options = {
    my.platformio = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = lib.mdDoc ''
          enable platformio udev rules
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    services.udev.packages = with pkgs; [ platformio-core.udev ];
  };
}
