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
    ./gtk
    ./haruna
    ./haskeline
    ./lsd
    ./newsboat
    ./pandoc
    ./picom
    ./qt
    ./qutebrowser
    ./polybar
    ./rofi
    ./syncthing
    ./vscode
    ./xdg
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
    xresources.properties = {
      "Xft.autohint" = 0;
      "Xft.hintstyle" = "hintfull";
      "Xft.hinting" = 1;
      "Xft.antialias" = 1;
      "Xft.rgba" = "rgb";
      "Xcursor.theme" = "Vanilla-DMZ-AA";
      "Xft.dpi" = 267;
      "Xcursor.size" = 120;
    };
    services = {
      screen-locker = {
        enable = true;
        lockCmd =
          "${pkgs.i3lock}/bin/i3lock --nofork --color=000000 --ignore-empty-password --show-failed-attempts";
        inactiveInterval = 5;
      };
      poweralertd.enable = true;
    };
    nixpkgs = {
      config = {
        allowUnfreePredicate = let
          xs = [
            "broadcom-sta"
            "discord"
            "gitkraken"
            "lastpass-cli"
            "mathpix-snipping-tool-03.00.0072"
          ];
          f = pkgs.lib.getName;
        in pkg: builtins.elem (f pkg) xs;
      };
      overlays = ol
        ++ [ (import ./qrcp "6969") (import ./xournal) (import ./reading) ];
    };
  };
}
