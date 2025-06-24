{ pkgs, config, lib, ... }:
with lib;
let cfg = config.unifi;
in {
  options = {
    unifi = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = lib.mdDoc ''
          enable unifi controller
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    services.unifi = {
      enable = true;
      openFirewall = true;
      unifiPackage = pkgs.unifi;
      extraJvmOptions = [ "-Djava.net.preferIPv4Stack=true" ];
    };
    networking = { firewall.allowedTCPPorts = [ 8443 ]; };
  };
}
