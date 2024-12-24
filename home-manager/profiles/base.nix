{ pkgs, ... }: {
  imports = [
    ../modules/atuin
    ../modules/autorandr
    ../modules/bat
    ../modules/direnv
    ../modules/fzf
    ../modules/git
    ../modules/lazygit
    ../modules/readline
    ../modules/ripgrep
    ../modules/starship
    ../modules/thunderbird
    ../modules/tmux
    ../modules/vifm
    ../modules/vifm/program.nix
    ../modules/yt-dlp
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
  };
}
