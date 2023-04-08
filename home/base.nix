{ config, lib, pkgs, ... }:

{
  imports = [
    ./alacritty
    ./bat
    ./ctags
    ./direnv
    ./fzf
    ./git
    ./github
    ./haruna
    ./haskeline
    ./lazygit
    ./lsd
    ./neovim
    ./newsboat
    ./pandoc
    ./picom
    ./polybar
    ./qutebrowser
    ./readline
    ./ripgrep
    ./rofi
    ./syncthing
    ./tmux
    ./vifm
    ./vscode
    ./xdg
    ./xmonad
    ./zathura
    ./zoxide
    ./zsh
  ];

  options = {
    theme = {
      enable = lib.mkEnableOption "theme";
      color = lib.mkOption {
        type = lib.types.str;
        default = "dark";
      };
    };
  };

  config = {

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
    programs = { home-manager.enable = true; };
  };
}
