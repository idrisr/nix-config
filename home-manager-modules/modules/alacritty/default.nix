{ config, pkgs, ... }: {
  config = {
    programs.alacritty = {
      enable = true;
      settings = {
        window = {
          decorations = "full";
          opacity = 1.0;
          padding = {
            x = 5;
            y = 5;
          };
        };
        shell = {
          program = "${pkgs.zsh}/bin/zsh";
          # args = [
          # "-c"
          # "${pkgs.tmuxp}/bin/tmuxp load /home/hippoid/tmuxp/session.yaml"
          # ];
        };

        font = {
          normal = {
            family = "JetBrainsMono Nerd Font";
            style = "Medium";
          };
          size = 10;
        };

        colors = import ./${config.theme.color}.nix;
      };
    };
  };
}
