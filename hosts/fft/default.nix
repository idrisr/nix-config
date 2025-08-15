{
  options = { };

  imports = [ ./hardware-fft.nix ];

  config = {
    my.base.enable = true;
    my.borgrepo.enable = true;
  };
}
