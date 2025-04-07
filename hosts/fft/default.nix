{
  options = { };

  imports = [
    ./hardware-fft.nix
    ../../nixos-modules/borg/borgrepo.nix
    ../../nixos-modules/jellyfin.nix
    ../../nixos-modules/frigate
  ];

  config = {
    base.enable = true;
    display.enable = true;
    home-assistant.enable = true;
    monitoring.enable = true;
    networking.adblocker.enable = false;
    nvidia-gpu.enable = true;
    ollama.enable = true;
    photoserver.enable = true;
    profile.dailydrive.enable = true;
    unifi.enable = false;
    virtualization.enable = true;
  };
}
