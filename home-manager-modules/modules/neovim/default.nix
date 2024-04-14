{ pkgs, config, ... }:
let
  vimBackground = "set background=${config.theme.color}";
  airlineBackground = "let g:airline_solarized_bg='${config.theme.color}'";
  cocSettings = builtins.readFile ./coc-settings.json;
  # maybe use concatTextFile

  regFiles = pkgs: dir:
    let
      f = x: dir + "/${x}";
      g = _: v: v == "regular";
      h = with pkgs.lib.attrsets;
        builtins.attrNames (filterAttrs g (builtins.readDir dir));
      i = map f h;
    in i;
  concatFiles = files:
    let
      j = map builtins.readFile files;
      k = builtins.concatStringsSep "\n" ([ " " ] ++ j);
    in k;
in {
  config = {
    xdg.configFile."nvim/coc-settings.json".text = cocSettings;

    programs.neovim = {
      enable = true;
      vimAlias = true;
      viAlias = true;
      vimdiffAlias = true;
      plugins = with pkgs.vimPlugins; [
        ale
        coc-emmet
        coc-html
        coc-nvim
        coc-pyright
        # coc-texlab
        coc-tsserver
        emmet-vim
        fzf-vim
        fugitive
        nerdcommenter
        nvim-hs-vim
        pkgs.zettel-plugin
        tagbar
        targets-vim
        ultisnips
        unicode-vim
        vim-airline
        vim-airline-themes
        vim-colors-solarized
        vim-css-color
        vim-easy-align
        vim-nix
        lean-nvim
        vim-obsession
        vim-scriptease
        vimspector
        vim-startify
        vim-surround
        vimtex
      ];

      extraLuaConfig = concatFiles (regFiles pkgs ./lua-plugin);

      extraConfig = let
        plugins = concatFiles (regFiles pkgs ./plugin);
        files = concatFiles [ ./vimrc ./autocommand.vim ./functions.vim ];
        last =
          builtins.concatStringsSep "\n" [ airlineBackground vimBackground ];
      in files + plugins + last;
    };
  };
}
