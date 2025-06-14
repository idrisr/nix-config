{ pkgs, lib, config, ... }:
with lib;
let cfg = config.mitm;
in {

  options = {
    mitm = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = lib.mdDoc ''
          enable mitmproxy stuff.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    security.pki.certificateFiles = [ ];
    environment.systemPackages = with pkgs; [ mitmproxy ];
  };
}
