{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/24.05";
    flake-utils.url = "github:numtide/flake-utils";
    pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";
    devenv.url = "github:cachix/devenv";
  };

  outputs = inputs@{ nixpkgs, flake-utils, ... }:
    let
      pkgs = nixpkgs.legacyPackages.${system};
      hooks = {
        nixfmt.enable = true;
        deadnix.enable = true;
        beautysh.enable = true;
      };

      system = flake-utils.lib.system.x86_64-linux;
      compiler = "ghc965";
      hPkgs = pkgs.haskell.packages."${compiler}";
      dTools = with pkgs; [
        zlib
        xorg.libX11
        xorg.xrandr
        xorg.libXrandr
        xorg.libXinerama
        xorg.libXScrnSaver
        xorg.libXext
        alsa-lib
      ];
      hTools = with hPkgs; [
        ghc
        ghcid
        fourmolu
        hlint
        hoogle
        haskell-language-server
        implicit-hie
        retrie
        cabal-install
        cabal-fmt
      ];
      tools = dTools ++ hTools;
      renameme =
        pkgs.haskell.packages.${compiler}.callCabal2nix "" ./renameme { };

    in {
      devShells.${system}.default = nixpkgs.legacyPackages.${system}.mkShell {
        inherit (self.checks.${system}.pre-commit-check) shellHook;
        buildInputs = self.checks.${system}.pre-commit-check.enabledPackages
          ++ tools;
        LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath tools;
      };

      packages.${system}.default = renameme;

      checks.${system} = {
        pre-commit-check = inputs.pre-commit-hooks.lib.${system}.run {
          src = ./.;
          inherit hooks;
        };
        inherit renameme;
      };
    };
}
