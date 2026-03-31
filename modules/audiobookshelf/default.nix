{ config
, lib
, ...
}:
with lib;
let
  cfg = config.my.audiobookshelf;
in
{
  options = {
    my.audiobookshelf = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = lib.mdDoc ''
          enable audiobookshelf
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    users.groups.hippoid = { };

    services.audiobookshelf = {
      enable = true;
      group = "hippoid";
      host = "0.0.0.0";
      port = 8000;
      openFirewall = true;
    };
  };
}
