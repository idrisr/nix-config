{ config
, lib
, ...
}:
with lib; let
  cfg = config.my.navidrome;
in
{
  options = {
    my.navidrome = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = lib.mdDoc ''
          enable navidrome
        '';
      };
      address = mkOption {
        default = "127.0.0.1";
        type = types.str;
        description = lib.mdDoc ''
          address for navidrome to listen on
        '';
      };
      allowedSource = mkOption {
        default = null;
        type = types.nullOr types.str;
        description = lib.mdDoc ''
          source address allowed through the firewall to reach navidrome
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    users.groups.hippoid = { };

    services.navidrome = {
      enable = true;
      group = "hippoid";
      settings = {
        Address = cfg.address;
        Port = 4533;
        MusicFolder = "/data/navidrome/music";
        DataFolder = "/data/navidrome/data";
        EnableInsightsCollector = false;
      };
    };

    networking.firewall.extraCommands = mkIf (cfg.allowedSource != null) ''
      iptables -A nixos-fw -p tcp -s ${cfg.allowedSource} --dport 4533 -j nixos-fw-accept
    '';

    systemd.tmpfiles.rules = [
      "d /data/navidrome 2775 hippoid hippoid -"
      "d /data/navidrome/music 2775 hippoid hippoid -"
      "d /data/navidrome/data 0700 navidrome hippoid -"
    ];
  };
}
