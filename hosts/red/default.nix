{
  imports = [ ./hardware-red.nix ];
  config = {
    monitoring.enable = true;
    base.enable = true;
  };
}
