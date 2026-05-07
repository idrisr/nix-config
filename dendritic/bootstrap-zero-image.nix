{ ... }:
{
  flake.modules.nixos.bootstrap-zero-image = import ../modules/bootstrap-zero-image.nix;
}
