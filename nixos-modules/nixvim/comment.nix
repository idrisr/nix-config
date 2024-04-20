{ pkgs, ... }: {
  config.programs.nixvim = {
    extraPlugins = [ pkgs.vimPlugins.nerdcommenter ];

    keymaps = [{
      key = "<leader>u";
      action = ":call UltiSnips#RefreshSnippets()<CR>";
      mode = "n";
    }];

    globals = {
      NERDSpaceDelims = 1;
      NERDCompactSexyComs = 1;
      NERDCustomDelimiters = { lhaskell = { "left" = ">"; }; };
    };
  };
}
