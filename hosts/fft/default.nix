{
  options = { };

  imports = [ ./hardware-fft.nix ];

  config = {
    my.base.enable = true;
    my.anki.enable = true;
    my.jellyfin.enable = true;
    my.borgrepo.enable = true;
    my.servernode.enable = true;
    networking.adblocker.enable = true;
  };
}
