{ pkgs, ... }: {
  imports = [
    ../modules/autorandr
    ../modules/bat
    ../modules/direnv
    ../modules/fzf
    ../modules/git
    ../modules/lazygit
    ../modules/neovim
    ../modules/readline
    ../modules/ripgrep
    ../modules/starship
    ../modules/theme.nix
    ../modules/thunderbird
    ../modules/tmux
    ../modules/vifm
    ../modules/zsh
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
      overlays =
        (let xs = [ ../modules/overlays/zettel-plugin.nix ]; in map import xs);
    };
  };
}
