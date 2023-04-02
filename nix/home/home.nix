{ config, lib, pkgs, ... }:

{
  imports = [
    ./alacritty
    ./bat
    ./direnv
    ./fzf
    ./git
    ./github
    ./lazygit
    ./lsd
    ./neovim
    ./pandoc
    ./picom
    ./qutebrowser
    ./rofi
    ./tmux
    ./vscode
    ./polybar
    ./xmonad
    ./zathura
    ./zoxide
    ./zsh
  ];

  xdg.mimeApps = let browser = "org.qutebrowser.qutebrowser.desktop";
  in {
    enable = true;
    defaultApplications = {
      "x-scheme-handler/http" = browser;
      "x-scheme-handler/https" = browser;
      "text/html" = browser;
      "application/pdf" = "org.pwmt.zathura.desktop";
      "application/vnd.oasis.opendocument.spreadsheet" =
        "libreoffice-calc.desktop";
    };
  };

  nixpkgs = {
    config = {
      allowUnfreePredicate = pkg:
        builtins.elem (pkgs.lib.getName pkg) [
          "vscode"
          "discord"
          "lastpass-cli"
          "vscode-extension-ms-vscode-cpptools"
          "steam-run"
          "steam-original"

        ];
    };
    overlays = [
      (import ./overlays/awscost.nix)
      (import ./overlays/epubthumbnailer.nix)
      (import ./overlays/pdftc.nix)
      (import ./overlays/transcribe.nix)
      (import ./overlays/mdtopdf.nix)
      (import ./overlays/dimensions.nix)
    ];
  };

  home = {
    username = "hippoid";
    homeDirectory = "/home/hippoid";
    stateVersion = "22.05";
    packages = (import ./packages.nix) pkgs;
  };

  # Let Home Manager install and manage itself.
  programs = {
    home-manager.enable = true;
    direnv.enable = true;
    direnv.nix-direnv.enable = true;
    readline.enable = true;
    readline.extraConfig = "set editing-mode vi";
  };
}
