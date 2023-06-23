{ config, pkgs, ... }: {
  config = {
    services.udev.extraRules = ''
      ACTION=="add", ATTRS{idProduct}=="1500", ATTRS{idVendor}=="05ac",
      DRIVERS=="usb", RUN+="${pkgs.sg_utils}/bin/sg_raw /dev/$kernel EA 00 00 00 00 00 01"'';
  };
  options = [ ];
  imports = { };
}
