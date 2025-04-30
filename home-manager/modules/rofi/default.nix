{ pkgs, ... }: {
  config = {
    programs.rofi = {
      enable = true;
      terminal = "${pkgs.kitty}/bin/kitty";
      location = "center";
      plugins = with pkgs; [ rofi-calc rofi-emoji rofi-power-menu ];
      theme = { "*" = { width = 1512; }; };

      extraConfig = {
        modi = "drun,run,ssh";
        kb-row-up = "Up,Alt+k";
        kb-row-down = "Down,Alt+j";
        dpi = 267;
        disable-history = true;
      };
    };
  };
}
