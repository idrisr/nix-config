{ lib, config, pkgs, ... }:
with lib;
let cfg = config.my.anki;
in {
  options = {
    my.anki = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = lib.mdDoc ''
          enable anki sync server
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    services.anki-sync-server = {
      enable = true;
      openFirewall = true;
      port = 27701;
      address = "0.0.0.0";
      users = [{
        username = "hippoid";
        password = "hippoid";
      }];
    };
  };
}
