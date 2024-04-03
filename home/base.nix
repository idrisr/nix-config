{ pkgs, ... }: {
  imports = [
    ./autorandr
    ./bat
    ./direnv
    ./fzf
    ./git
    ./lazygit
    ./neovim
    ./readline
    ./ripgrep
    ./starship
    ./theme.nix
    ./thunderbird
    ./tmux
    ./vifm
    ./zsh
  ];

  config = {
    home = {
      username = "hippoid";
      homeDirectory = "/home/hippoid";
      stateVersion = "22.05";
      packages = import ./base-packages.nix pkgs;
    };

    # Let Home Manager install and manage itself.
    programs = { home-manager.enable = true; };
    nixpkgs = {
      overlays = (let xs = [ ./overlays/zettel-plugin.nix ]; in map import xs);
    };
  };
}
