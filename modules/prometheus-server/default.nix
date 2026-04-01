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
    environment.etc = {
      "grafana-dashboards/node-fleet-overview.json".source = ./dashboards/node-fleet-overview.json;
      "grafana-dashboards/node-host-basic.json".source = ./dashboards/node-host-basic.json;
      "grafana-dashboards/router-overview.json".source = ./dashboards/router-overview.json;
      "grafana-dashboards/gpu-fft-node.json".source = ./dashboards/gpu-fft-node.json;
      "grafana-dashboards/laptop-batteries.json".source = ./dashboards/laptop-batteries.json;
      "grafana-dashboards/mac-mini-overview.json".source = ./dashboards/mac-mini-overview.json;
      "grafana-dashboards/frigate-overview.json".source = ./dashboards/frigate-overview.json;
    };

    services.grafana = {
      enable = true;
      provision = {
        enable = true;
        datasources.settings = {
          apiVersion = 1;
          datasources = [
            {
              name = "Prometheus";
              type = "prometheus";
              access = "proxy";
              url = "http://127.0.0.1:9090";
              isDefault = true;
              uid = "effpfi5egefwgf";
            }
          ];
        };
        dashboards.settings = {
          apiVersion = 1;
          providers = [
            {
              name = "default";
              options.path = "/etc/grafana-dashboards";
            }
          ];
        };
      };
      settings = {
        security.secret_key = "/etc/letsencrypt/live/idrisraja.com/privkey.pem";

        server = {
          http_port = 3010;
        };
        dashboards.default_home_dashboard_path = "/etc/grafana-dashboards/node-host-basic.json";
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
