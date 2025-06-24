{ pkgs, config, lib, ... }:
with lib;
let cfg = config.my.exitnode;
in {
  options = {
    my.exitnode = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = lib.mdDoc ''
          enable exit node
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    services.tailscale = {
      enable = true;
      useRoutingFeatures = "client";
    };
  };
}
