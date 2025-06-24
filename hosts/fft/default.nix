{
  options = { };

  imports = [ ./hardware-fft.nix ../../nixos-modules/jellyfin.nix ];

  config = {
    base.enable = true;
    display.enable = true;
    home-assistant.enable = false;
    monitoring.enable = true;
    my.borgrepo.enable = true;
    networking.adblocker.enable = false;
    nvidia-gpu.enable = false;
    ollama.enable = false;
    photoserver.enable = false;
    profile.dailydrive.enable = false;
    unifi.enable = false;
    virtualization.enable = true;
  };
}
