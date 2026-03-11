{ pkgs
, inputs
, ...
}: {
  options = { };

  imports = [
    ./hardware-fft.nix
    # inputs.dcgm.nixosModules.dcgm-exporter
  ];

  config = {
    nvidia-gpu.enable = true;
    ollama.enable = true;
    my.base.enable = true;
    my.anki.enable = true;
    my.jellyfin.enable = true;
    my.immich.enable = true;
    my.borgrepo.enable = true;
    my.servernode.enable = true;
    networking.firewall.allowedTCPPorts = [ 80 443 ];

    services.nginx = {
      enable = true;
      recommendedGzipSettings = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      virtualHosts = {
        "ai.idrisraja.com" = {
          forceSSL = true;
          sslCertificate = "/etc/letsencrypt/live/idrisraja.com/fullchain.pem";
          sslCertificateKey = "/etc/letsencrypt/live/idrisraja.com/privkey.pem";
          locations."/" = {
            proxyPass = "http://127.0.0.1:13221";
            proxyWebsockets = true;
          };
        };
        "jellyfin.idrisraja.com" = {
          forceSSL = true;
          sslCertificate = "/etc/letsencrypt/live/idrisraja.com/fullchain.pem";
          sslCertificateKey = "/etc/letsencrypt/live/idrisraja.com/privkey.pem";
          locations."/" = {
            proxyPass = "http://127.0.0.1:8096";
            proxyWebsockets = true;
          };
        };
        "immich.idrisraja.com" = {
          forceSSL = true;
          sslCertificate = "/etc/letsencrypt/live/idrisraja.com/fullchain.pem";
          sslCertificateKey = "/etc/letsencrypt/live/idrisraja.com/privkey.pem";
          locations."/" = {
            proxyPass = "http://127.0.0.1:2283";
            proxyWebsockets = true;
          };
        };

        "grafana.idrisraja.com" = {
          forceSSL = true;
          sslCertificate = "/etc/letsencrypt/live/idrisraja.com/fullchain.pem";
          sslCertificateKey = "/etc/letsencrypt/live/idrisraja.com/privkey.pem";
          locations."/" = {
            proxyPass = "http://127.0.0.1:3010";
            proxyWebsockets = true;
          };
        };

        "unifi.idrisraja.com" = {
          forceSSL = true;
          sslCertificate = "/etc/letsencrypt/live/idrisraja.com/fullchain.pem";
          sslCertificateKey = "/etc/letsencrypt/live/idrisraja.com/privkey.pem";
          locations."/" = {
            proxyPass = "https://127.0.0.1:8443";
            proxyWebsockets = true;
          };
        };

        "prometheus.idrisraja.com" = {
          forceSSL = true;
          sslCertificate = "/etc/letsencrypt/live/idrisraja.com/fullchain.pem";
          sslCertificateKey = "/etc/letsencrypt/live/idrisraja.com/privkey.pem";
          locations."/" = {
            proxyPass = "http://127.0.0.1:9090";
          };
        };

        "router.idrisraja.com" = {
          forceSSL = true;
          sslCertificate = "/etc/letsencrypt/live/idrisraja.com/fullchain.pem";
          sslCertificateKey = "/etc/letsencrypt/live/idrisraja.com/privkey.pem";
          locations."/" = {
            proxyPass = "http://192.168.8.1";
          };
        };
      };
    };

    services.nix-serve = {
      enable = true;
      secretKeyFile = "/var/lib/nix-serve/cache-priv-key.pem";
      openFirewall = true;
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
