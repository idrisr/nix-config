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
    services.grafana.enable = false;
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
