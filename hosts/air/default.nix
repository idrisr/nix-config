{
  imports = [ ./hardware-air.nix ];
  config = {
    monitoring.enable = false;
    base.enable = true;
    display.enable = false;
    my.borgrepo.enable = true;
  };
}
