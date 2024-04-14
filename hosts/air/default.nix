{
  imports = [ ./hardware-air.nix ../../nixos-modules/borg/borgrepo.nix ];
  config = {
    monitoring.enable = true;
    base.enable = true;
    display.enable = false;
  };
}
