{ config, lib, ... }:

with lib;
let
  cfg = config.hardware.superdrive;
  adguardPort = 3000;
in {

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
        settings = {
          bind_port = adguardPort;
          schema_version = 20;
        };
      };
    };
  };
}
