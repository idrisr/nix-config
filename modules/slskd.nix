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

    services.nfs.server = {
      enable = true;
      exports = ''
        /srv/slskd 192.168.1.0/24(rw,sync,no_subtree_check) 172.16.1.0/24(rw,sync,no_subtree_check) 100.116.126.91(rw,sync,no_subtree_check,all_squash,anonuid=988,anongid=980)
        /srv/slskd/downloads 192.168.1.0/24(rw,sync,no_subtree_check) 172.16.1.0/24(rw,sync,no_subtree_check) 100.116.126.91(rw,sync,no_subtree_check,all_squash,anonuid=988,anongid=980)
      '';
    };

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

    systemd.services.slskd.serviceConfig.UMask = "0002";

    systemd.tmpfiles.rules = [
      "d /srv/slskd 2775 slskd hippoid -"
      "d /srv/slskd/downloads 2775 slskd hippoid -"
      "d /srv/slskd/incomplete 2775 slskd hippoid -"
    ];
  };
}
