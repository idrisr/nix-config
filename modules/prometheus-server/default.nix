{ config, lib, ... }:
with lib; let
  cfg = config.my.prometheus-server;
in
{
  options = {
    my.prometheus-server = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = lib.mdDoc ''
          enable prometheus server
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    services.grafana = {
      enable = true;
      settings = {
        security.secret_key = "/etc/letsencrypt/live/idrisraja.com/privkey.pem";

        server = {
          http_port = 3010;
        };
        analytics.reporting_enabled = false;
      };
    };
    services.prometheus = {
      enable = true;
      configText = builtins.readFile ./prometheus.yml;
      # scrapeConfigs = [
      # {
      # job_name = "systemd";
      # static_configs = [
      # { targets = [ "127.0.0.1:9558" ]; }
      # ];
      # }

      # {
      # job_name = "framework";
      # static_configs = [
      # { targets = [ "127.0.0.1:9100" ]; }
      # ];
      # }
      # ];
    };
  };
}
