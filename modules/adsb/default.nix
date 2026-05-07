{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.adsb;
  tar1090 = pkgs.callPackage ../../packages/tar1090.nix { };
  aircraftDb = pkgs.fetchurl {
    url = "https://github.com/wiedehopf/tar1090-db/raw/csv/aircraft.csv.gz";
    hash = "sha256-gPyZK18f9PXtp1EtzG86DWg92uSC/DC0yHatxVIxzmM=";
  };
in
{
  options.my.adsb = {
    enable = lib.mkEnableOption "ADS-B decoding with readsb and tar1090";

    siteName = lib.mkOption {
      type = lib.types.str;
      default = "tar1090";
      description = lib.mdDoc "URL path prefix used for the tar1090 web UI.";
    };

    readsb = {
      lat = lib.mkOption {
        type = lib.types.float;
        default = 41.9742;
        description = lib.mdDoc "Receiver latitude for readsb position decoding.";
      };

      lon = lib.mkOption {
        type = lib.types.float;
        default = -87.9073;
        description = lib.mdDoc "Receiver longitude for readsb position decoding.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.readsb tar1090 ];

    users.users.readsb = {
      isSystemUser = true;
      group = "readsb";
      extraGroups = [ "plugdev" ];
    };

    users.groups.readsb = { };

    systemd.tmpfiles.rules = [
      "d /run/readsb 0755 readsb readsb -"
      "d /run/tar1090/chunks 0755 nginx nginx -"
      "d /run/tar1090/db2 0755 nginx nginx -"
      "f /run/tar1090/db2/ranges.js 0644 nginx nginx - []"
    ];

    systemd.services.tar1090-support-files = {
      description = "Generate tar1090 support files";
      wantedBy = [ "multi-user.target" ];
      after = [ "readsb.service" ];
      requires = [ "readsb.service" ];
      serviceConfig = {
        Type = "simple";
        User = "nginx";
        Group = "nginx";
        Restart = "always";
        RestartSec = 5;
      };
      script = ''
        set -euo pipefail
        while true; do
          ${pkgs.coreutils}/bin/mkdir -p /run/tar1090/chunks /run/tar1090/db2
          ${pkgs.coreutils}/bin/printf '[]\n' > /run/tar1090/db2/ranges.js

          ${pkgs.findutils}/bin/find /run/readsb -maxdepth 1 -name 'globe_*.json' -printf '%f\n' \
            | ${pkgs.gnugrep}/bin/grep '^globe_[0-9]\+\.json$' \
            | ${pkgs.coreutils}/bin/sort \
            | ${pkgs.jq}/bin/jq -R -s 'split("\n")[:-1] | map(sub("^globe_"; "") | sub("\\.json$"; "") | tonumber)' \
            > /run/tar1090/chunks/chunks.json.tmp

          ${pkgs.coreutils}/bin/mv /run/tar1090/chunks/chunks.json.tmp /run/tar1090/chunks/chunks.json
          ${pkgs.coreutils}/bin/chmod 0644 /run/tar1090/chunks/chunks.json /run/tar1090/db2/ranges.js
          sleep 30
        done
      '';
    };

    systemd.services.readsb = {
      description = "ADS-B decoder";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      serviceConfig = {
        User = "readsb";
        Group = "readsb";
        SupplementaryGroups = [ "plugdev" ];
        RuntimeDirectory = "readsb";
        RuntimeDirectoryMode = "0755";
        StateDirectory = "readsb";
        Restart = "on-failure";
        RestartSec = 2;
        ExecStart = ''
          ${pkgs.readsb}/bin/readsb \
            --device-type rtlsdr \
            --gain 37.2 \
            --lat ${toString cfg.readsb.lat} \
            --lon ${toString cfg.readsb.lon} \
            --db-file ${aircraftDb} \
            --write-json /run/readsb \
            --write-json-every 1 \
            --write-json-globe-index \
            --net \
            --net-bind-address 127.0.0.1 \
            --net-api-port 30152 \
            --tar1090-use-api
        '';
      };
    };

    services.nginx.enable = true;
    services.nginx.virtualHosts.localhost.locations = {
      "/${cfg.siteName}/" = {
        alias = "${tar1090}/share/tar1090/html/";
        extraConfig = ''
          index index.html;
        '';
      };

      "/${cfg.siteName}/data/" = {
        alias = "/run/readsb/";
      };

      "/${cfg.siteName}/chunks/" = {
        alias = "/run/tar1090/chunks/";
      };

      "/${cfg.siteName}/db2/" = {
        alias = "/run/tar1090/db2/";
      };

      "/${cfg.siteName}/re-api/" = {
        proxyPass = "http://127.0.0.1:30152/";
      };
    };
  };
}
