{ pkgs, ... }:
let compiler = "ghc965";
in {
  packages = with pkgs.haskell.packages."${compiler}";
    [ fourmolu cabal-fmt implicit-hie ghcid ] ++ (with pkgs; [
      zlib
      xorg.libX11
      alsa-lib
      xorg.xrandr
      xorg.libXrandr
      xorg.libXinerama
      xorg.libXScrnSaver
      xorg.libXext
    ]);

  languages.haskell.enable = true;
}
