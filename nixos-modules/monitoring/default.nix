{ config, lib, ... }:

# https://github.com/starcraft66/nix-dotnet-aspire-dashboard
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
