{ pkgs, ... }: {
  config = {
    programs.rofi = {
      enable = true;
      terminal = "${pkgs.alacritty}/bin/alacritty";
      font = "hack 24";
      location = "center";
      plugins = with pkgs; [ rofi-calc rofi-emoji rofi-power-menu ];
      extraConfig = {
        modi = "drun,emoji,ssh";
        kb-row-up = "Up,Alt+k";
        kb-row-down = "Down,Alt+j";
      };
    };
  };
}
