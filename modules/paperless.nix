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
      "d /var/paperless 2770 paperless users -"
      "d /var/paperless/data 2770 paperless users -"
      "d /var/paperless/media 2770 paperless users -"
      "d /var/paperless/consume 2770 paperless users -"
      "d /var/paperless/export 2770 paperless users -"
    ];

    services.paperless = {
      enable = true;
      inherit port;
      dataDir = "/var/paperless/data";
      mediaDir = "/var/paperless/media";
      consumptionDir = "/var/paperless/consume";

      consumptionDirIsPublic = true;
      openMPThreadingWorkaround = true;
      database.createLocally = true;
      exporter = {
        enable = true;
        directory = "/var/paperless/export";
        onCalendar = "daily";
      };
      settings = {
        PAPERLESS_CONSUMER_RECURSIVE = true;
        PAPERLESS_CONSUMER_SUBDIRS_AS_TAGS = true;
        PAPERLESS_OCR_LANGUAGE = "eng";
        PAPERLESS_ENABLE_NLTK = false;
        PAPERLESS_OCR_MODE = "off";
        PAPERLESS_EMAIL_TASK_CRON = "disable";
        # Disable Paperless's automatic ML classifier and prevent use of any
        # previously trained model.
        PAPERLESS_TRAIN_TASK_CRON = "disable";
        PAPERLESS_MODEL_FILE = "/var/paperless/data/classification_model.disabled";
      };
    };
  };
}
