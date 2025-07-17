{ config, lib, ... }:
with lib;
let cfg = config.rustdesk;
in {
  options = {
    rustdesk = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = lib.mdDoc ''
          enable rustdesk rdp
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    services.rustdesk-server = {
      enable = true;
      openFirewall = true;
      relay.enable = false;
    };
  };
}
