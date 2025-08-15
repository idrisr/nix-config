{ config, lib, pkgs, ... }:
let cfg = config.my.printer;
in {
  options = {
    my.printer = {
      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = lib.mdDoc ''
          turn on the local printer finder thinger
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.printing = {
      enable = true;
      drivers = [ pkgs.brlaser ];
    };

    hardware.printers = {
      ensurePrinters = [{
        name = "bro2300";
        deviceUri = "usb://Brother/HL-L2300D%20series?serial=U63878J1N698009";
        model = "drv:///brlaser.drv/brl2300d.ppd";
      }];
      ensureDefaultPrinter = "bro2300";
    };

    users.users.hippoid.extraGroups = [ "lpadmin" ];
    environment.systemPackages = [ pkgs.brlaser ];
  };
}
