{ pkgs, host, ... }:
let
  dpiMap = {
    "surface" = 267;
    "framework" = 180;
  };
in {
  imports = [
    ./base.nix
    ../modules/alacritty
    ../modules/kitty
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
      "Xft.dpi" = dpiMap.${host} or 200;
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
  };
}
