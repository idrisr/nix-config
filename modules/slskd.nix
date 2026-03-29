{ config
, lib
, ...
}:
with lib;
let
  cfg = config.my.slskd;
  navidromeMusicFolder = lib.attrByPath [ "services" "navidrome" "settings" "MusicFolder" ] "/srv/navidrome/music" config;
in
{
  options = {
    my.slskd = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = lib.mdDoc ''
          enable slskd
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    users.groups.hippoid = { };

    services.slskd = {
      enable = true;
      domain = null;
      group = "hippoid";
      environmentFile = "/srv/slskd/slskd.env";
      openFirewall = true;
      settings = {
        web.port = 5030;
        directories = {
          downloads = "/srv/slskd/downloads";
          incomplete = "/srv/slskd/incomplete";
        };
        shares.directories = [ navidromeMusicFolder ];
      };
    };

    systemd.tmpfiles.rules = [
      "d /srv/slskd 2775 slskd hippoid -"
      "d /srv/slskd/downloads 2775 slskd hippoid -"
      "d /srv/slskd/incomplete 2775 slskd hippoid -"
    ];
  };
}
