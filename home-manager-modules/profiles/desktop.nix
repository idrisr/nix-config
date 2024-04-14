{ pkgs, inputs, ... }:
let
  ol = (with inputs.knotools.overlays; [
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
in {

  imports = [
    ./base.nix
    ../modules/alacritty
    ../modules/ctags
    ../modules/emacs
    ../modules/firefox
    ../modules/github
    ../modules/gtk
    ../modules/haruna
    ../modules/haskeline
    ../modules/lsd
    ../modules/newsboat
    ../modules/pandoc
    ../modules/picom
    ../modules/polybar
    ../modules/qt
    ../modules/qutebrowser
    ../modules/rofi
    ../modules/syncthing
    ../modules/vscode
    ../modules/xdg
    ../modules/zathura
    ../modules/zoxide
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
      "Xft.dpi" = 267;
    };
    services = {
      screen-locker = {
        enable = true;
        lockCmd =
          "${pkgs.i3lock}/bin/i3lock --nofork --color=000000 --ignore-empty-password --show-failed-attempts";
        inactiveInterval = 15;
      };
      poweralertd.enable = true;
    };
    nixpkgs = {
      config = {
        allowUnfreePredicate = pkg:
          builtins.elem (pkgs.lib.getName pkg) [
            "broadcom-sta"
            "discord"
            "gitkraken"
            "lastpass-cli"
            "mathpix-snipping-tool-03.00.0072"
            "makemkv"
          ];
      };
      overlays = ol ++ [
        # (import ./briss)
        (import ../modules/qrcp "6969")
        (import ../modules/xournal)
        (import ../modules/reading)
        (import ../modules/tikzit)
      ];
    };
  };
}
