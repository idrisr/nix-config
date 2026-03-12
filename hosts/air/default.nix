{
  imports = [ ./hardware-air.nix ];
  config = {
    my.base.enable = true;
    my.borgrepo.enable = true;
  };
}
