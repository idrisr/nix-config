{ lib
, pkgs
, inputs
, ...
}: {
  options = { };

  imports = [
    ./hardware-fft.nix
    # inputs.dcgm.nixosModules.dcgm-exporter
  ];

  config = {
    my = {
      printer.enable = true;
      printer.local.enable = true;
      printServer.enable = true;
      base.enable = true;
      "initrd-remote-unlock".enable = true;
      anki.enable = true;
      jellyfin.enable = true;
      immich.enable = true;
      borgrepo.enable = true;
      servernode.enable = false;
    };

    nvidia-gpu.enable = true;
    ollama.enable = true;
    nvr.enable = true;
    programs.hyprland.enable = lib.mkForce false;
    services.greetd.enable = lib.mkForce false;
    networking.firewall.allowedTCPPorts = [ 80 443 9187 ];

    services.nginx = {
      enable = true;
      virtualHosts."frigate-metrics" = {
        listen = [
          {
            addr = "0.0.0.0";
            port = 9187;
          }
          {
            addr = "[::]";
            port = 9187;
          }
        ];

        locations."/metrics" = {
          proxyPass = "http://127.0.0.1:5000/api/metrics";
          extraConfig = ''
            allow 192.168.8.0/24;
            allow 127.0.0.1;
            deny all;
          '';
        };

        locations."/".return = "404";
      };
    };

    services.nix-serve = {
      enable = true;
      secretKeyFile = "/var/lib/nix-serve/cache-priv-key.pem";
      openFirewall = true;
      port = 5949;
    };

    environment.systemPackages = with pkgs; [
      atuin
      binutils
      lego
      certbot
    ];
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      extraSpecialArgs = {
        inherit inputs;
        graphical = false;
        pkgs = pkgs;
      };
      users.hippoid = import (inputs."home-config" + "/home.nix");
    };
  };
}
