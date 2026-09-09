{ config, lib, ... }:
let
  cfg = config.my.fft-sanoid;
in
{
  options.my.fft-sanoid.enable = lib.mkEnableOption "Sanoid and Syncoid backups for fft";

  config = lib.mkIf cfg.enable {
    services.sanoid = {
      enable = true;

      datasets."tank/data" = {
        useTemplate = [ "data" ];
        recursive = true;
      };

      templates.data = {
        hourly = 24;
        daily = 14;
        monthly = 12;
        yearly = 1;
        autosnap = true;
        autoprune = true;
      };
    };

    services.syncoid = {
      enable = true;
      interval = "hourly";

      commands."tank/data" = {
        target = "backup/data";
        recursive = true;
        sendOptions = "w";
      };
    };
  };
}
