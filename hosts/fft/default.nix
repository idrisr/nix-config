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
    display.enable = false;
    home-assistant.enable = true;
    monitoring.enable = true;
    nvidia-gpu.enable = true;
    ollama.enable = false;
    unifi.enable = true;
  };
}
