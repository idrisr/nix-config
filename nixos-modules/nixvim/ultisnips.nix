{ pkgs, ... }: {
  config.programs.nixvim = {
    extraPlugins = [ pkgs.vimPlugins.ultisnips ];
    keymaps = [{
      key = "<leader>u";
      action = ":call UltiSnips#RefreshSnippets()<CR>";
      mode = "n";
    }];
    globals = {
      UltiSnipsSnippetDirectories =
        [ "/home/hippoid/dotfiles/nixos-modules/nixvim/snippets/" ];
    };
  };
}
