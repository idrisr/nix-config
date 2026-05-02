{ ... }:
{
  flake.modules.nixos.bootstrap-rpi4-image = import ../modules/bootstrap-rpi4-image.nix;
}
