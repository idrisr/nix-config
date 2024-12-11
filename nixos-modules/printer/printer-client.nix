{ config, lib, pkgs, ... }:
let
  printer_name = "Brother_HL-L2300D_series";
  cfg = config.local.printer;
in {
  options = {
    local.printer = {
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
    services.printing.enable = true;

    hardware.printers = {
      # # ensurePrinters = [{
      # # name = printer_name;
      # # location = "3112";
      # # deviceUri = "ipp://BRW6814015277E8.local:631/ipp/print";
      # # # deviceUri =
      # # # "dnssd://Brother%20HL-L2300D%20series%20%40%20red._ipp._tcp.local/cups?uuid=5cfc6423-a6d0-34cc-5cdb-47d50800ef6f";
      # # # model = "drv:///brlaser.drv/brl2300d.ppd";
      # # model = "";
      # # ppdOptions = { PageSize = "A4"; };
      # # }];
      ensureDefaultPrinter = printer_name;
    };
    environment.systemPackages = [ pkgs.brlaser ];
  };
}
