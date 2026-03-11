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
      hosts = {
        "192.168.8.231" = [
          "ai.idrisraja.com"
          "jellyfin.idrisraja.com"
          "immich.idrisraja.com"
          "adguard.idrisraja.com"
          "unifi.idrisraja.com"
        ];
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
                answer = "192.168.8.231";
              }
              {
                domain = "jellyfin.idrisraja.com";
                answer = "192.168.8.231";
              }
              {
                domain = "immich.idrisraja.com";
                answer = "192.168.8.231";
              }
              {
                domain = "adguard.idrisraja.com";
                answer = "192.168.8.231";
              }
            ];
          };
        };
      };
    };
  };
}
