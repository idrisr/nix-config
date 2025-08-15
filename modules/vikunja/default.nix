{ config, lib, ... }:
let
  cfg = config.my.vikunja;
in
{
  options = {
    my.vikunja = {
      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description =
          lib.mdDoc "whether to enable vikunja to-do service";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.vikunja = {
      enable = true;
      frontendScheme = "http";
      frontendHostname = "localhost";
    };
  };
}
