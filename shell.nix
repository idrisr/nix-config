let pkgs = import <nixpkgs> { };
in with pkgs;
mkShell {
  buildInputs = [
    ghcid
    (ghc.withPackages (p: with p; [ xmonad xmonad-extras dbus ]))
    haskell-language-server

  ];
}
