{ config
, lib
, ...
}:
with lib;
let
  cfg = config.my.paperless;
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

      domain = mkOption {
        default = "paperless.idrisraja.com";
        type = types.str;
        description = lib.mdDoc ''
          public domain for paperless-ngx
        '';
      };

      acmeHost = mkOption {
        default = "idrisraja.com";
        type = types.str;
        description = lib.mdDoc ''
          ACME certificate name to use for nginx
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    services.paperless = {
      enable = true;
      address = "127.0.0.1";
      port = 28981;
      dataDir = "/persist/paperless/data";
      mediaDir = "/persist/paperless/media";
      consumptionDir = "/persist/paperless/consume";
      openMPThreadingWorkaround = true;
      database.createLocally = true;
      exporter = {
        enable = true;
        directory = "/persist/paperless/export";
        onCalendar = "daily";
      };
      settings = {
        PAPERLESS_URL = "https://${cfg.domain}";
        PAPERLESS_OCR_LANGUAGE = "eng";
        PAPERLESS_OCR_MODE = "auto";
        PAPERLESS_ENABLE_NLTK = false;
      };
    };

    services.nginx.virtualHosts.${cfg.domain} = {
      forceSSL = true;
      useACMEHost = cfg.acmeHost;
      locations."/" = {
        proxyPass = "http://${config.services.paperless.address}:${toString config.services.paperless.port}";
        proxyWebsockets = true;
      };
    };

    systemd.tmpfiles.rules = [
      "d /persist/paperless 0755 paperless paperless -"
      "d /persist/paperless/consume 0750 paperless paperless -"
      "d /persist/paperless/data 0700 paperless paperless -"
      "d /persist/paperless/export 0700 paperless paperless -"
      "d /persist/paperless/media 0700 paperless paperless -"
    ];
  };
}
