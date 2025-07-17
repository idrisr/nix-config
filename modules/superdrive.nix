{ config, lib, pkgs, ... }:

let cfg = config.hardware.superdrive;
in {

  options = {
    hardware.superdrive = {
      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = lib.mdDoc ''
          Enable superdrive udev rule.
          This will send magic bits to superdrive upon detection to make it
          plug-and-play.
          see https://kuziel.nz/notes/2018/02/apple-superdrive-linux.html
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ sg3_utils ];
    services.udev.extraRules = ''
      ACTION=="add", ATTRS{idProduct}=="1500", ATTRS{idVendor}=="05ac",
      DRIVERS=="usb", RUN+="${pkgs.sg3_utils}/bin/sg_raw /dev/$kernel EA 00 00 00 00 00 01"'';
  };
}
