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
      dataDir = "/srv/paperless/data";
      mediaDir = "/srv/paperless/media";
      consumptionDir = "/srv/paperless/consume";
      openMPThreadingWorkaround = true;
      database.createLocally = true;
      exporter = {
        enable = true;
        directory = "/srv/paperless/export";
        onCalendar = "daily";
      };
      settings = {
        PAPERLESS_URL = "https://${cfg.domain}";
        PAPERLESS_OCR_LANGUAGE = "eng";
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
      "d /srv/paperless 0755 paperless paperless -"
      "d /srv/paperless/consume 0750 paperless paperless -"
      "d /srv/paperless/data 0700 paperless paperless -"
      "d /srv/paperless/export 0700 paperless paperless -"
      "d /srv/paperless/media 0700 paperless paperless -"
    ];
  };
}
