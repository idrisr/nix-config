{ config
, lib
, pkgs
, inputs
, ...
}:
{
  options = { };

  imports = [
    ./hardware-fft.nix
    # inputs.dcgm.nixosModules.dcgm-exporter
  ];

  config = {
    my = {
      printer.enable = true;
      printServer.enable = true;
      base.enable = true;
      "initrd-remote-unlock".enable = true;
      anki.enable = true;
      navidrome = {
        enable = true;
        address = "192.168.8.231";
        allowedSource = "192.168.8.224";
      };
      jellyfin.enable = true;
      immich.enable = true;
      paperless = {
        enable = false;
        address = "192.168.8.231";
        allowedSource = "192.168.8.224";
        domain = "paperless.idrisraja.com";
        taskWorkers = 4;
        threadsPerWorker = 4;
        webserverWorkers = 2;
      };
      esphome = {
        enable = true;
        address = "0.0.0.0";
        openFirewall = true;
      };
      borgrepo.enable = true;
      kismet = {
        enable = true;
        interface = "wlp8s0";
      };
      servernode.enable = false;
      wifi-bssid-monitor = {
        enable = false;
        interface = "wlp8s0";
        interval = "1m";
        minSignalDbm = -75;
        randomizedDelaySec = "0s";
      };
    };

    nvidia-gpu.enable = true;
    my.adsb.enable = true;
    sdr.enable = true;
    sdr.web.enable = false;
    ollama.enable = true;
    nvr.enable = true;
    programs.hyprland.enable = lib.mkForce false;
    services.greetd.enable = lib.mkForce false;
    networking.firewall.allowedTCPPorts = [
      80
      443
      8080
      9187
    ];
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

    security.acme = {
      acceptTerms = true;
      defaults.email = "idris.raja@gmail.com";
      certs."idrisraja.com" = {
        dnsProvider = "namecheap";
        environmentFile = "/var/lib/acme/namecheap.env";
        group = "nginx";
        reloadServices = [ "nginx.service" ];
        extraDomainNames = [ "*.idrisraja.com" ];
      };
    };

    services.atticd = {
      enable = true;
      environmentFile = "/var/lib/atticd/atticd.env";
      settings = {
        listen = "[::]:8080";
        api-endpoint = "http://fft:8080/";
        allowed-hosts = [
          "fft:8080"
          "fft"
        ];
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

    system.activationScripts.attic-cache-bootstrap =
      let
        atticAdminConfig = pkgs.writeText "attic-admin.toml" ''
          allowed-hosts = ['fft:8080', 'fft']
          api-endpoint = 'http://fft:8080/'
          listen = '[::]:8080'

          [chunking]
          avg-size = 65536
          max-size = 262144
          min-size = 16384
          nar-size-threshold = 65536

          [database]
          url = 'sqlite:///var/lib/atticd/server.db?mode=rwc'

          [storage]
          path = '/var/lib/atticd/storage'
          type = 'local'
        '';
      in
      ''
        if [ -e /var/lib/atticd/atticd.env ]; then
          tmp_config_dir="$(${pkgs.coreutils}/bin/mktemp -d)"
          trap '${pkgs.coreutils}/bin/rm -rf "$tmp_config_dir"' EXIT
          export XDG_CONFIG_HOME="$tmp_config_dir"
          . /var/lib/atticd/atticd.env
          export ATTIC_SERVER_TOKEN_RS256_SECRET_BASE64
          token="$(${pkgs.attic-server}/bin/atticadm -f ${atticAdminConfig} make-token --sub bootstrap --validity '10 years' --pull 'main' --push 'main' --create-cache 'main' --configure-cache 'main')"
          ${pkgs.attic-client}/bin/attic login local http://fft:8080 "$token" >/dev/null
          if ! ${pkgs.attic-client}/bin/attic cache info local:main >/dev/null 2>&1; then
            ${pkgs.attic-client}/bin/attic cache create local:main --public >/dev/null
          fi
          ${pkgs.coreutils}/bin/rm -rf "$tmp_config_dir"
          trap - EXIT
        fi
      '';

    systemd.services.attic-watch-store =
      let
        atticAdminConfig = pkgs.writeText "attic-watch-store.toml" ''
          allowed-hosts = ['fft:8080', 'fft']
          api-endpoint = 'http://fft:8080/'
          listen = '[::]:8080'

          [chunking]
          avg-size = 65536
          max-size = 262144
          min-size = 16384
          nar-size-threshold = 65536

          [database]
          url = 'sqlite:///var/lib/atticd/server.db?mode=rwc'

          [storage]
          path = '/var/lib/atticd/storage'
          type = 'local'
        '';
      in
      {
        description = "Watch local store and push paths to Attic";
        after = [ "atticd.service" ];
        wants = [ "atticd.service" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          Type = "simple";
          Restart = "always";
          RestartSec = 10;
        };
        script = ''
          set -euo pipefail

          export XDG_CONFIG_HOME="$(${pkgs.coreutils}/bin/mktemp -d)"
          trap '${pkgs.coreutils}/bin/rm -rf "$XDG_CONFIG_HOME"' EXIT

          . /var/lib/atticd/atticd.env
          export ATTIC_SERVER_TOKEN_RS256_SECRET_BASE64
          token="$(${pkgs.attic-server}/bin/atticadm -f ${atticAdminConfig} make-token --sub watch-store --validity '10 years' --pull 'main' --push 'main')"

          ${pkgs.attic-client}/bin/attic login local http://fft:8080 "$token" >/dev/null
          exec ${pkgs.attic-client}/bin/attic watch-store --ignore-upstream-cache-filter local:main
        '';
      };

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
