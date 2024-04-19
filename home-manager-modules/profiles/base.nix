{ pkgs, inputs, ... }: {
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
    inputs.nix-colors.homeManagerModules.default
    ../modules/test.nix
  ];

  config = {
    colorScheme = inputs.nix-colors.colorSchemes.gruvbox-dark-medium;

    home = {
      username = "hippoid";
      homeDirectory = "/home/hippoid";
      stateVersion = "22.05";
      packages = import ./base-packages.nix pkgs;
    };

    # Let Home Manager install and manage itself.
    programs = { home-manager.enable = true; };
  };
}
