{
  # todo: fixme so it figures out light/dark from colorscheme
  config = {
    programs.lazygit = {
      enable = true;
      settings = {
        gui = {
          theme = { showCommandLog = false; };
          git = { };
          disableStartupPopups = true;
          keybinding = { universal = { select = "a"; }; };
        };
      };
    };
  };
}
