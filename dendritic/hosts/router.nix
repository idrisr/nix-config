{...}: {
  flake.modules.nixos.router = import ../../hosts/router/default.nix;
}
