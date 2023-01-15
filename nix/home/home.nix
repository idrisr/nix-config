{ config, lib, pkgs, ... }:

{
  imports = [ ./bat ./fzf ./git ./github ./lazygit ./neovim ./tmux ./zsh ];

  home = {
    username = "hippoid";
    homeDirectory = "/home/hippoid";
    stateVersion = "22.05";
    packages = (import ./base-packages.nix) pkgs;
  };

  # Let Home Manager install and manage itself.
  programs = {
    home-manager.enable = true;
    readline.enable = true;
    readline.extraConfig = "set editing-mode vi";

  };
}
