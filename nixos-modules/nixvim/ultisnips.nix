{ pkgs, ... }: {
  config.programs.nixvim = {
    extraPlugins = [ pkgs.vimPlugins.ultisnips ];
    keymaps = [{
      key = "<leader>u";
      action = ":call UltiSnips#RefreshSnippets()<CR>";
      mode = "n";
    }];
    globals = {
      UltiSnipsSnippetDirectories = [
        "/home/hippoid/dotfiles/home-manager-modules/modules/neovim/snippets/"
      ];
    };
  };
}

# let g:UltiSnipsSnippetStorageDirectoryForUltiSnipsEdit='/home/hippoid/dotfiles/home/neovim/plugin'
