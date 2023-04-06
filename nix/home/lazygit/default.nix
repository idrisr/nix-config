{
  config = {
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
  };
}
