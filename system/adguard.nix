{ pkgs, lib, ... }: {
  config = {
    networking = {
      firewall = {
        allowedTCPPorts = [ 3000 ];
        allowedUDPPorts = [ 53 ];
      };
    };

    services = {
      adguardhome = {
        enable = true;
        openFirewall = true;
        settings.bind_port = 3000;
      };
    };
  };
}
