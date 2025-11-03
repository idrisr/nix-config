{ config, lib, ... }:
let
  cfg = config.my.pinchflat;
in
{
  options = {
    my.pinchflat = {
      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description =
          lib.mdDoc "whether to enable the youtube download pinchflat";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.pinchflat.serviceConfig.UMask = "0002";
    services.pinchflat = {
      enable = false;
      selfhosted = true;
      openFirewall = true;
    };

    users = {
      users.hippoid = {
        extraGroups = [ "pinchflat" ];
      };
    };
  };
}
