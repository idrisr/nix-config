{ config
, lib
, ...
}:
with lib; let
  cfg = config.networking.adblocker;
  adguardPort = 3000;
  idrisrajaHosts = import ../lib/idrisraja-hosts.nix;
  adguardRewrites = mapAttrsToList
    (domain: answer: {
      inherit domain answer;
    })
    idrisrajaHosts;
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
            rewrites = adguardRewrites;
          };
        };
      };
    };
  };
}
