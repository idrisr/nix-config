{
  config = {
    programs.nixvim = {
      autoCmd = [
        {
          event = [ "BufEnter" ];
          pattern = [ "*.tex" ];
          command = ":setlocal textwidth=0";
        }
        {
          event = [ "BufEnter" ];
          pattern = [ "*.purs" ];
          command = ":setlocal filetype=purescript";
        }
        {
          event = [ "BufEnter" ];
          pattern = [ "*.pl" ];
          command = ":setlocal filetype=prolog";
        }
      ];
    };
  };
}
