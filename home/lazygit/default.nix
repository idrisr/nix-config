{ config, ... }:
let
  str2Bool = (x: if x == "dark" then false else true);
  isLight = str2Bool config.theme.color;
in {
  config = {
    programs.lazygit = {
      enable = true;
      settings = {
        gui = {
          theme = {
            lightTheme = isLight;
            showCommandLog = false;
          };
          git = { };
          disableStartupPopups = true;
          keybinding = { universal = { select = "a"; }; };
        };
      };
    };
  };
}
