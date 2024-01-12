{ config, pkgs, lib, ... }:
let printer_name = "Brother_HL-L2300D_series";
in {
  config = {
    hardware.printers = {
      ensurePrinters = [{
        name = printer_name;
        location = "apt";
        deviceUri = "usb://Brother/HL-L2300D%20series?serial=U63878J1N698009";
        # deviceUri =
        # "dnssd://Brother%20HL-L2300D%20series%20%40%20red._ipp._tcp.local/cups?uuid=5cfc6423-a6d0-34cc-5cdb-47d50800ef6f";
        model = "drv:///brlaser.drv/brl2300d.ppd";
        ppdOptions = { PageSize = "A4"; };
      }];
      ensureDefaultPrinter = printer_name;
    };
    environment.systemPackages = [ pkgs.brlaser ];
  };
}
