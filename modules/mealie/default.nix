{ config
, lib
, ...
}:
with lib; let
  cfg = config.my.mealie;
in

{
  options = {
    my.mealie = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = lib.mdDoc ''
          enable mealie
        '';
      };
    };
  };
  config = mkIf cfg.enable {
    services.mealie.enable = true;
    networking.firewall.allowedTCPPorts = [ config.services.mealie.port ];
  };
}
