knotools:
let
  ol = (with knotools.overlays; [
    awscost
    booknote
    epubthumb
    mdtopdf
    newcover
    pdftc
    roamamer
    seder
    transcribe
  ]);
in { config, lib, pkgs, ... }: {

  imports = [
    ./alacritty
    ./base.nix
    ./ctags
    ./emacs
    ./firefox
    ./github
    ./haruna
    ./haskeline
    ./lsd
    ./newsboat
    ./pandoc
    ./picom
    ./qt
    ./qutebrowser
    ./rofi
    ./syncthing
    ./vscode
    ./xdg
    ./xmonad
    ./zathura
    ./zoxide
  ];

  config = {
    home = {
      username = "hippoid";
      homeDirectory = "/home/hippoid";
      stateVersion = "22.05";
      packages = import ./desktop-packages.nix pkgs;
    };
    nixpkgs = {
      config = {
        allowUnfreePredicate = let
          xs = [ "broadcom-sta" "discord" "gitkraken" "lastpass-cli" ];
          f = pkgs.lib.getName;
        in pkg: builtins.elem (f pkg) xs;
      };
      overlays = ol;
    };

  };
}
