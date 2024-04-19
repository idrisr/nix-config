{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware";
    flake-utils.url = "github:numtide/flake-utils";
    nix-colors.url = "github:misterio77/nix-colors";
    knotools.url =
      "github:idrisr/knotools/6eebffaf8e43aea9e33c73e3bcb70815e3e783d8";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # zettel.url = "github:idrisr/zettel";
    zettel.url = "path:/home/hippoid/fun/zettel";
  };

  outputs = inputs@{ nixpkgs, flake-utils, ... }:
    let
      # system = flake-utils.lib.system.x86_64-linux;
      # pkgs = import nixpkgs { inherit system; };
      makeMachine = host:
        nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [ ./hosts/${host} ./nixos-modules ];
        };
    in {
      nixosConfigurations = { # todo use a fmap
        air = makeMachine "air";
        fft = makeMachine "fft";
        framework = makeMachine "framework";
        surface = makeMachine "surface";
      };

      # devShells.${system} = {
      # default = with pkgs;
      # mkShell {
      # buildInputs = [
      # ghcid
      # (ghc.withPackages (p: with p; [ xmonad xmonad-extras dbus ]))
      # haskell-language-server
      # luajitPackages.lua-lsp
      # nodePackages.vim-language-server
      # ];
      # };
      # };

    };
}
