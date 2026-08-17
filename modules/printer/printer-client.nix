{ config
, lib
, pkgs
, ...
}:
with lib;
let
  cfg = config.my.printer;
  printerUri =
    if cfg.local.enable then
      "usb://Brother/HL-L2300D%20series?serial=U63878J1N698009"
    else
      "ipp://${cfg.serverHost}:631/printers/${cfg.name}";
  printerModel =
    if cfg.local.enable then
      "drv:///brlaser.drv/brl2300d.ppd"
    else
      "everywhere";
in
{
  options = {
    my.printer = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = mdDoc ''
          configure the Brother printer queue for this host
        '';
      };
    };
  };

  config = mkIf cfg.enable
    {
      services.printing.enable = true;

      services.avahi = {
        enable = true;
        nssmdns4 = true;
        openFirewall = true;
      };

      users.users.hippoid.extraGroups = [ "lpadmin" ];
    };
}
