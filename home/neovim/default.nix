{ pkgs, config, ... }:
let
  vimBackground = "set background=${config.theme.color}";
  airlineBackground = "let g:airline_solarized_bg='${config.theme.color}'";
  cocSettings = builtins.readFile ./coc-settings.json;

in {
  config = {
    xdg.configFile."nvim/coc-settings.json".text = cocSettings;
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

      extraConfig = with pkgs.lib.attrsets;
        let
          f = builtins.readFile;
          g = _: v: v == "regular";
          h = x: ./plugin + "/${x}";

          names = builtins.readDir ./plugin;
          paths = map h (builtins.attrNames (filterAttrs g names));

          # separate lists used to enforce ordering
          first = [ (f ./vimrc) ];
          middle = map f ([ ./autocommand.vim ./functions.vim ] ++ paths);
          last = [ airlineBackground vimBackground ];
          xs = builtins.concatLists [ first middle last ];
        in builtins.concatStringsSep "\n" xs;
    };
  };
}
