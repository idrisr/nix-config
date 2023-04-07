{ config, ... }: {
  config = {
    programs.alacritty = {
      enable = true;
      settings = {
        window = {
          decorations = "full";
          opacity = 0.9;
          padding = {
            x = 5;
            y = 5;
          };
        };

        font = {
          normal = { style = "Medium"; };
          size = 14;
        };

        colors = import ./${config.theme.color}.nix;
      };
    };
  };
}
