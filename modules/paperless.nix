{ config
, lib
, ...
}:
with lib;
let
  cfg = config.my.paperless;
  port = 28981;
in
{
  options = {
    my.paperless = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = lib.mdDoc ''
          enable paperless-ngx
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    users.users.hippoid.extraGroups = [ "paperless" ];

    systemd.tmpfiles.rules = [
      "d /data/paperless 2770 paperless users -"
      "d /data/paperless/data 2770 paperless users -"
      "d /data/paperless/media 2770 paperless users -"
      "d /data/paperless/consume 2770 paperless users -"
      "d /data/paperless/export 2770 paperless users -"
    ];

    services.paperless = {
      enable = true;
      inherit port;
      dataDir = "/data/paperless/data";
      mediaDir = "/data/paperless/media";
      consumptionDir = "/data/paperless/consume";

      consumptionDirIsPublic = true;
      openMPThreadingWorkaround = true;
      database.createLocally = true;
      exporter = {
        enable = true;
        directory = "/data/paperless/export";
        onCalendar = "daily";
      };
      settings = {
        PAPERLESS_CONSUMER_RECURSIVE = true;
        PAPERLESS_CONSUMER_SUBDIRS_AS_TAGS = true;
        PAPERLESS_OCR_LANGUAGE = "eng";
        PAPERLESS_ENABLE_NLTK = false;
      };
    };
  };
}
