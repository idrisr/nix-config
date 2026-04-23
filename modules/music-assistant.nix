{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.my.music-assistant;
in
{
  options = {
    my.music-assistant = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = lib.mdDoc ''
          enable music assistant server
        '';
      };

      openFirewall = mkOption {
        default = true;
        type = types.bool;
        description = lib.mdDoc ''
          open firewall ports required by music assistant
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    services.music-assistant = {
      enable = true;
      openFirewall = cfg.openFirewall;
    };
  };
}
