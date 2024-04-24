{ config, pkgs, ... }: {
  config = {
    programs.alacritty = {
      enable = false;
      settings = {
        colors = with config.colorScheme.palette;
          let f = x: "0x${builtins.substring 0 6 x}";
          in {
            bright = {
              black = f base00;
              blue = f base0D;
              cyan = f base0C;
              green = f base0B;
              magenta = f base0E;
              red = f base08;
              white = f base06;
              yellow = f base09;
            };
            cursor = {
              cursor = f base06;
              text = f base06;
            };
            normal = {
              black = f base00;
              blue = f base0D;
              cyan = f base0C;
              green = f base0B;
              magenta = f base0E;
              red = f base08;
              white = f base06;
              yellow = f base0A;
            };
            primary = {
              background = f base00;
              foreground = f base06;
            };
          };
        window = {
          decorations = "full";
          opacity = 0.85;
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
      };
    };
  };
}
