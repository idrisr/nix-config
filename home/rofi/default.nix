{ pkgs, ... }:

{
  config = {
    programs.rofi = {
      enable = true;
      terminal = "${pkgs.alacritty}/bin/alacritty";
      font = "hack 24";
      location = "center";
      theme = ./nord.rasi;
    };
  };
}
