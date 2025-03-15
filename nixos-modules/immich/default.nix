{ config, lib, ... }:
with lib;
let cfg = config.photoserver;
in {
  options = {
    photoserver = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = lib.mdDoc ''
          enable photoserver, immich
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    services.immich = {
      enable = true;
      openFirewall = true;
      machine-learning.enable = true;
      host = "0.0.0.0";
    };
  };
}
