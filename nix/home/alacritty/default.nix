{ config, ... }: {
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

      # solarized dark
      # better way to bring in themes?
      colors = import ./dark.nix;
    };
  };
}
