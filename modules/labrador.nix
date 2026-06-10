{ config
, lib
, ...
}:
let
  cfg = config.hardware.labrador;
in
{
  options = {
    hardware.labrador = {
      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = lib.mdDoc ''
          Enable udev rules for Espotek Labrador devices.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.udev.extraRules = ''
      SUBSYSTEM=="usb", ATTR{idVendor}=="03eb", ATTR{idProduct}=="ba94", MODE:="0666", TAG+="uaccess"
      SUBSYSTEM=="usb", ATTR{idVendor}=="03eb", ATTR{idProduct}=="a000", MODE:="0666", TAG+="uaccess"
      SUBSYSTEM=="usb", ATTR{idVendor}=="03eb", ATTR{idProduct}=="2fe4", MODE:="0666", TAG+="uaccess"
    '';
  };
}
