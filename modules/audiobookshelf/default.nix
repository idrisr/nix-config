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

    services.nfs.server = {
      enable = true;
      exports = ''
        /srv/audiobooks 192.168.1.0/24(rw,sync,no_subtree_check) 172.16.1.0/24(rw,sync,no_subtree_check) 100.116.126.91(rw,sync,no_subtree_check,all_squash,anonuid=987,anongid=980)
      '';
    };

    services.audiobookshelf = {
      enable = true;
      group = "hippoid";
      host = "0.0.0.0";
      port = 8000;
      openFirewall = true;
    };

    systemd.services.audiobookshelf.serviceConfig.UMask = "0002";

    systemd.tmpfiles.rules = [
      "d /srv/audiobooks 2775 audiobookshelf hippoid -"
      "Z /srv/audiobooks 2775 audiobookshelf hippoid -"
    ];
  };
}
