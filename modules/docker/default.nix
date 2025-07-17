{ config, lib, ... }:
with lib;
let cfg = config.docker;
in {
  options = {
    docker = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = lib.mdDoc ''
          Enable local docker.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    virtualisation.docker.enable = true;
    # todo: add group membership thing
  };
}
