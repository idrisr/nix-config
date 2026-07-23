{ config
, lib
, ...
}:
with lib; let
  cfg = config.my.servernode;
in
{
  options = {
    my.servernode = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = lib.mdDoc ''
          enable exit node
        '';
      };

      advertiseRoutes = mkOption {
        default = [ ];
        type = types.listOf types.str;
        description = lib.mdDoc ''
          subnet routes to advertise through Tailscale
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    services.tailscale = {
      enable = true;
      useRoutingFeatures = "server";
      extraSetFlags = optional (cfg.advertiseRoutes != [ ]) "--advertise-routes=${concatStringsSep "," cfg.advertiseRoutes}";
    };
  };
}
