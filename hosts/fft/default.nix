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
      esphome = {
        enable = true;
        address = "0.0.0.0";
        openFirewall = true;
      };
      borgrepo.enable = true;
      servernode.enable = false;
    };

    nvidia-gpu.enable = true;
    sdr.enable = true;
    sdr.web.enable = true;
    ollama.enable = true;
    nvr.enable = true;
    programs.hyprland.enable = lib.mkForce false;
    services.greetd.enable = lib.mkForce false;
    networking.firewall.allowedTCPPorts = [ 80 443 8080 9187 ];
    nix.gc.options = lib.mkForce "--delete-older-than 45d";

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

    services.atticd = {
      enable = true;
      environmentFile = "/var/lib/atticd/atticd.env";
      settings = {
        listen = "[::]:8080";
        api-endpoint = "http://fft:8080/";
        allowed-hosts = [ "fft:8080" "fft" ];
      };
    };

    system.activationScripts.atticd-env = ''
            if [ ! -e /var/lib/atticd/atticd.env ]; then
              install -d -m 0700 /var/lib/atticd
              token="$(${pkgs.openssl}/bin/openssl genrsa -traditional 4096 | ${pkgs.coreutils}/bin/base64 -w0)"
              umask 0077
              cat > /var/lib/atticd/atticd.env <<EOF
      ATTIC_SERVER_TOKEN_RS256_SECRET_BASE64=$token
      EOF
            fi
    '';

    environment.systemPackages = with pkgs; [
      attic-client
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
