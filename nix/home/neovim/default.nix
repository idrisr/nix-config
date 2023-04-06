{ pkgs, config, ... }:
let
  vimBackground = "set background=${config.theme.color}";
  airlineBackground = "let g:airline_solarized_bg='${config.theme.color}'";

in {
  config = {
    programs.neovim = {
      enable = true;
      vimAlias = true;

      plugins = with pkgs.vimPlugins; [
        ale
        coc-emmet
        coc-nvim
        emmet-vim
        fugitive
        fzf-vim
        nerdcommenter
        nvim-hs-vim
        tagbar
        ultisnips
        vim-airline
        vim-airline-themes
        vim-colors-solarized
        vim-css-color
        vim-easy-align
        vim-nix
        vim-obsession
        vim-racket
        vim-scriptease
        vimspector
        vim-startify
        vim-surround
        vimtex
      ];

      extraConfig = builtins.concatStringsSep "\n" [
        # leave this first
        (builtins.readFile ./vimrc)
        vimBackground

        (builtins.readFile ./autocommand.vim)
        (builtins.readFile ./functions.vim)
        (builtins.readFile ./plugin/airline.vim)
        airlineBackground

        (builtins.readFile ./plugin/ale.vim)
        (builtins.readFile ./plugin/coc.vim)
        (builtins.readFile ./plugin/emmet.vim)
        (builtins.readFile ./plugin/fugitive.vim)
        (builtins.readFile ./plugin/fzf.vim)
        (builtins.readFile ./plugin/latex.vim)
        (builtins.readFile ./plugin/nerdcommenter.vim)
        (builtins.readFile ./plugin/roam.vim)
        (builtins.readFile ./plugin/solarized.vim)
        (builtins.readFile ./plugin/surround.vim)
        (builtins.readFile ./plugin/tagbar.vim)
        (builtins.readFile ./plugin/ultisnips.vim)
        (builtins.readFile ./plugin/viewdoc.vim)
        (builtins.readFile ./plugin/vimtex.vim)
      ];
    };
  };
}
