{
  config.programs.nixvim.plugins.vimtex = {
    enable = true;
    settings = {
      quickfix_autoclose_after_keystrokes = 3;
      quickfix_open_on_warning = 0;
      view_method = "zathura";
      compiler_latexmk = {
        executable = "latexmk";
        continuous = 1;
        callback = 1;
        engine = "-pdf";
        viewer = "General";
        options = [
          "-synctex=1"
          "-interaction=nonstopmode"
          "-file-line-error"
          "-verbose"
          "-shell-escape"
        ];
      };
    };
  };
}
