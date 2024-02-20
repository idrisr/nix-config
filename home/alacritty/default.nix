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
          args = [
            "-c"
            "${pkgs.tmuxp}/bin/tmuxp load /home/hippoid/tmuxp/session.yaml"
          ];
        };

        font = {
          normal = { style = "Medium"; };
          size = 9;
        };

        colors = import ./${config.theme.color}.nix;
      };
    };
  };
}
