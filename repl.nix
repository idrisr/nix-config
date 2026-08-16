rec {
  pkgs = builtins.getFlake "nixpkgs";
  lib = pkgs.lib;
  nc = builtins.getFlake "/home/hippoid/nixos-config";
  h = builtins.getFlake "/home/hippoid/home-manager-config";
  has = builtins.getFlake "github:input-output-hk/haskell.nix";
  fft = nc.outputs.nixosConfigurations.fft;
  fr = nc.outputs.nixosConfigurations.framework;
  air = nc.outputs.nixosConfigurations.air;
  godel = nc.outputs.nixosConfigurations.godel;
  hm = builtins.getFlake "github:nix-community/home-manager";
  nv = builtins.getFlake "github:nix-communiy/nixvim";
  nd = builtins.getFlake "github:nix-darwin/nix-darwin";
  id = builtins.getFlake "github:idrisr/idris-pkgs";
  mac = nc.outputs.darwinConfigurations.mini;
}
