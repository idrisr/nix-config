{
  imports = [
    ./hardware-fft.nix
    ../../nixos-modules/borg/borgrepo.nix
    ../../nixos-modules/jellyfin.nix
    ../../nixos-modules/ollama
    ../../nixos-modules/frigate
  ];
  config = {
    monitoring.enable = true;
    base.enable = true;
    display.enable = false;
    nvidia-gpu.enable = true;
  };
}
