{ ... }: {
  flake.modules.nixos.rpi4 = import ../../hosts/rpi4/default.nix;
}
