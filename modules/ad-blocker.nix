{ config
, lib
, ...
}:
with lib; let
  cfg = config.networking.adblocker;
  adguardPort = 3000;
in
{
  options = {
    networking.adblocker = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = lib.mdDoc ''
          enable adguard on port 3000
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    networking = {
      firewall = {
        allowedTCPPorts = [ adguardPort ];
        allowedUDPPorts = [ 53 ];
      };
    };

    services = {
      adguardhome = {
        enable = true;
        openFirewall = true;
        port = adguardPort;
        settings = {
          # bind_port = adguardPort;
          schema_version = 20;
          dns = {
            rewrites = [
              {
                domain = "ai.idrisraja.com";
                answer = "192.168.8.224";
              }
              {
                domain = "jellyfin.idrisraja.com";
                answer = "192.168.8.224";
              }
              {
                domain = "immich.idrisraja.com";
                answer = "192.168.8.224";
              }
              {
                domain = "adguard.idrisraja.com";
                answer = "192.168.8.224";
              }
              {
                domain = "unifi.idrisraja.com";
                answer = "192.168.8.224";
              }
              {
                domain = "mealie.idrisraja.com";
                answer = "192.168.8.224";
              }
              {
                domain = "navidrome.idrisraja.com";
                answer = "192.168.8.224";
              }
              {
                domain = "slskd.idrisraja.com";
                answer = "192.168.8.224";
              }
              {
                domain = "audiobookshelf.idrisraja.com";
                answer = "192.168.8.224";
              }
              {
                domain = "prometheus.idrisraja.com";
                answer = "192.168.8.224";
              }
              {
                domain = "grafana.idrisraja.com";
                answer = "192.168.8.224";
              }
              {
                domain = "frigate.idrisraja.com";
                answer = "192.168.8.224";
              }
              {
                domain = "homeassistant.idrisraja.com";
                answer = "192.168.8.224";
              }
            ];
          };
        };
      };
    };
  };
}
