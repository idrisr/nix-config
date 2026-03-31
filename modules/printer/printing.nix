{ config
, lib
, pkgs
, ...
}:
with lib;
let
  cfg = config.my.printServer;
in
{
  options = {
    my.printServer = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = lib.mdDoc ''
          enable CUPS sharing and AirPrint advertisement
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    services = {
      ipp-usb.enable = true;

      avahi = {
        enable = true;
        nssmdns4 = true;
        openFirewall = true;
        publish = {
          enable = true;
          userServices = true;
        };
      };

      printing = {
        enable = true;
        drivers = [ pkgs.brlaser ];
        listenAddresses = [ "*:631" ];
        openFirewall = true;
        defaultShared = true;
        browsing = true;
        allowFrom = [ "@LOCAL" ];
        stateless = false;
        logLevel = "debug";
        extraConf = ''
          BrowseLocalProtocols dnssd
          BrowseDNSSDSubTypes _cups,_print,_universal
          DefaultEncryption Never
        '';
      };
    };

    users.users.hippoid = {
      extraGroups = [
        "lp"
        "lpadmin"
      ];
    };
  };
}
