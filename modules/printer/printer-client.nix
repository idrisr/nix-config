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

      name = mkOption {
        default = "bro2300";
        type = types.str;
        description = mdDoc ''
          printer queue name to create locally
        '';
      };

      serverHost = mkOption {
        default = "fft";
        type = types.str;
        description = mdDoc ''
          CUPS server host used by remote printer clients
        '';
      };

      local = {
        enable = mkOption {
          default = false;
          type = types.bool;
          description = mdDoc ''
            use directly attached USB printer instead of remote IPP queue
          '';
        };
      };
    };
  };

  config = mkIf cfg.enable {
    services.printing = {
      enable = true;
      drivers = optionals cfg.local.enable [ pkgs.brlaser ];
    };

    hardware.printers = {
      ensurePrinters = [
        {
          name = cfg.name;
          deviceUri = printerUri;
          model = printerModel;
        }
      ];
      ensureDefaultPrinter = cfg.name;
    };

    users.users.hippoid.extraGroups = [ "lpadmin" ];
    environment.sessionVariables.LPDEST = cfg.name;
    environment.systemPackages = optionals cfg.local.enable [ pkgs.brlaser ];
  };
}
