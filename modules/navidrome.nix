{ config
, lib
, ...
}:
with lib; let
  cfg = config.my.navidrome;
in
{
  options = {
    my.navidrome = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = lib.mdDoc ''
          enable navidrome
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    users.groups.hippoid = { };

    services.navidrome = {
      enable = true;
      group = "hippoid";
      settings = {
        Address = "127.0.0.1";
        Port = 4533;
        MusicFolder = "/srv/navidrome/music";
        DataFolder = "/srv/navidrome/data";
        EnableInsightsCollector = false;
      };
    };

    systemd.tmpfiles.rules = [
      "d /srv/navidrome 2775 hippoid hippoid -"
      "d /srv/navidrome/music 2775 hippoid hippoid -"
      "d /srv/navidrome/data 0700 navidrome hippoid -"
    ];
  };
}
