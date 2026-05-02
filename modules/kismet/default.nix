{ config, lib, ... }:
with lib;
let
  cfg = config.my.kismet;
in
{
  options.my.kismet = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc "Enable Kismet capture and its local HTTP UI.";
    };

    interface = mkOption {
      type = types.str;
      default = "";
      example = "wlp8s0";
      description = lib.mdDoc "Wi-Fi interface Kismet should capture from.";
    };

    proxyPort = mkOption {
      type = types.port;
      default = 2501;
      description = lib.mdDoc "Port where Kismet HTTP listens on the LAN.";
    };

    sourceName = mkOption {
      type = types.str;
      default = "kismet-mon";
      description = lib.mdDoc "Friendly source name shown in Kismet.";
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.interface != "";
        message = "my.kismet.interface must be set when Kismet is enabled.";
      }
    ];

    services.kismet = {
      enable = true;
      httpd = {
        enable = true;
        address = "0.0.0.0";
        port = cfg.proxyPort;
      };
      settings = {
        source.${cfg.interface} = {
          name = cfg.sourceName;
        };
      };
    };

    networking.firewall.allowedTCPPorts = [ cfg.proxyPort ];
  };
}
