{ config
, lib
, ...
}:
with lib; let
  cfg = config.my.kavita;
  port = 5000;
in
{
  options = {
    my.kavita = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = lib.mdDoc ''
          enable kavita
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    services.kavita = {
      enable = true;
      tokenKeyFile = "/var/lib/kavita/token.key";
      settings = {
        IpAddresses = "0.0.0.0,::";
        Port = port;
      };
    };

    networking.firewall.allowedTCPPorts = [ port ];
  };
}
