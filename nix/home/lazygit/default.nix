{ config, pkgs, ... }:
let a = "'a'";
in {
  programs.lazygit = {
    enable = true;
    settings = {
      gui = {
        theme = {
          lightTheme = false;
          showCommandLog = false;
        };
        git = { };
        disableStarturPopups = true;
        keybinding = { universal = { select = "a"; }; };
      };
    };
  };
}
