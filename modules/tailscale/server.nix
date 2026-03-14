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
    };
  };

  config = mkIf cfg.enable {
    services.tailscale = {
      enable = true;
      useRoutingFeatures = "server";
      extraUpFlags = [ "--advertise-routes=192.168.8.0/24" ];
    };
  };
}
