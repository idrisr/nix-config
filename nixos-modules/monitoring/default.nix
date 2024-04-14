{ config, lib, ... }:

with lib;
let cfg = config.monitoring;
in {

  options = {
    monitoring = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = lib.mdDoc ''
          Enable monitoring. Currently just cockpit.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    services = {
      cockpit = {
        enable = true;
        openFirewall = true;
      };
    };
  };
}
