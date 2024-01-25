{ pkgs, ... }: {
  config = {
    services = {
      ipp-usb.enable = true;

      avahi = {
        enable = true;
        nssmdns = true;
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
        allowFrom = [ "all" ];
        stateless = false;
        logLevel = "debug";
        extraConf = ''
          DefaultEncryption Never
        '';
      };
    };
    users.users.hippoid = { extraGroups = [ "lp" "lpadmin" ]; };
  };
}
