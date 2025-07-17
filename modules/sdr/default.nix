{ config, pkgs, lib, ... }:
with lib;
let cfg = config.sdr;
in {
  options = {
    sdr = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = lib.mdDoc ''
          enable software defined radio
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    hardware.rtl-sdr.enable = true;
    users.users.hippoid.extraGroups = [ "plugdev" ];
    services.sdrplayApi.enable = true;

    nixpkgs = {
      config.allowUnfreePredicate = pkg:
        builtins.elem (lib.getName pkg) [ "sdrplay" ];
      overlays = [
        (_: prev: {
          soapysdr-with-plugins = prev.soapysdr.override {
            extraPackages = with prev; [ soapyrtlsdr sdrplay ];
          };
        })
      ];
    };

    environment.systemPackages = with pkgs; [
      rtl-sdr
      soapysdr-with-plugins
      soapyremote
    ];
  };
}
