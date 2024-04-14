{
  imports = [
    ./hardware-fft.nix
    ../../nixos-modules/borg/borgrepo.nix
    ../../nixos-modules/jellyfin.nix
    ../../nixos-modules/nvidia
    ../../nixos-modules/ollama
  ];
  config = {
    monitoring.enable = true;
    base.enable = true;
    display.enable = true;
  };
}
