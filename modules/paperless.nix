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

      address = mkOption {
        default = "127.0.0.1";
        type = types.str;
        description = lib.mdDoc ''
          address for paperless-ngx to listen on
        '';
      };

      allowedSource = mkOption {
        default = null;
        type = types.nullOr types.str;
        description = lib.mdDoc ''
          source address allowed to access paperless-ngx directly
        '';
      };

      taskWorkers = mkOption {
        default = 1;
        type = types.ints.positive;
        description = lib.mdDoc ''
          number of paperless-ngx task workers
        '';
      };

      threadsPerWorker = mkOption {
        default = 2;
        type = types.ints.positive;
        description = lib.mdDoc ''
          number of paperless-ngx threads per worker
        '';
      };

      webserverWorkers = mkOption {
        default = 1;
        type = types.ints.positive;
        description = lib.mdDoc ''
          number of paperless-ngx webserver workers
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    users.groups.hippoid = { };
    users.users.hippoid.extraGroups = [ "hippoid" ];
    users.users.paperless.extraGroups = [ "hippoid" ];

    services.paperless = {
      enable = true;
      address = cfg.address;
      inherit port;
      dataDir = "/srv/paperless/data";
      mediaDir = "/srv/paperless/media";
      consumptionDir = "/srv/paperless/consume";
      consumptionDirIsPublic = true;
      openMPThreadingWorkaround = true;
      database.createLocally = true;
      exporter = {
        enable = true;
        directory = "/srv/paperless/export";
        onCalendar = "daily";
      };
      settings = {
        PAPERLESS_CONSUMER_RECURSIVE = true;
        PAPERLESS_CONSUMER_SUBDIRS_AS_TAGS = true;
        PAPERLESS_URL = "https://${cfg.domain}";
        PAPERLESS_OCR_LANGUAGE = "eng";
        PAPERLESS_TASK_WORKERS = cfg.taskWorkers;
        PAPERLESS_THREADS_PER_WORKER = cfg.threadsPerWorker;
        PAPERLESS_WEBSERVER_WORKERS = cfg.webserverWorkers;
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
      "d /srv/paperless 0755 paperless hippoid -"
      "d /srv/paperless/consume 2775 paperless hippoid -"
      "Z /srv/paperless/consume 2775 paperless hippoid -"
      "d /srv/paperless/data 0700 paperless paperless -"
      "d /srv/paperless/export 0700 paperless paperless -"
      "d /srv/paperless/media 0700 paperless paperless -"
    ];

    networking.firewall.extraCommands = ''
      ${optionalString (cfg.allowedSource != null) ''
        iptables -A nixos-fw -p tcp -s ${cfg.allowedSource} --dport ${toString port} -j nixos-fw-accept
      ''}
    '';
  };
}
