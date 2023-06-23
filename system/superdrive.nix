{ config, pkgs, ... }: {
  # https://kuziel.nz/notes/2018/02/apple-superdrive-linux.html
  config = {
    services.udev.extraRules = ''
      ACTION=="add", ATTRS{idProduct}=="1500", ATTRS{idVendor}=="05ac",
      DRIVERS=="usb", RUN+="${pkgs.sg3_utils}/bin/sg_raw /dev/$kernel EA 00 00 00 00 00 01"'';
  };
  options = { };
  imports = [ ];
}
