{ pkgs, ... }:
let
  # maybe use concatTextFile
  concatFiles = files:
    let
      j = map builtins.readFile files;
      k = builtins.concatStringsSep "\n" ([ " " ] ++ j);
    in k;
in {
  imports = [
    ./align.nix
    ./comment.nix
    ./fugitive.nix
    ./keymap.nix
    ./latex.nix
    ./lsp.nix
    ./neo-tree.nix
    ./cmp.nix
    ./oil.nix
    ./ollama.nix
    ./surround.nix
    ./telescope.nix
    ./transparent.nix
    ./ultisnips.nix # move to other snip thing
    ./whichkey.nix
    ./vimrc.nix
  ];

  config.programs.nixvim = {
    enable = true;
    viAlias = true;
    vimAlias = true;

    colorschemes.gruvbox.enable = true;
    extraPlugins = with pkgs.vimPlugins; [
      ale
      fzf-vim # switch to fzf-lua?
      pkgs.zettel # option or module in flake with other packages
      nvim-lspconfig
    ];

    # should be an option declared as a list
    # then merged together
    # so everything can live in the right file
    extraConfigVim = concatFiles [ ./vimrc ./ale.vim ./fzf.vim ];
    extraConfigLua = concatFiles [ ./fzf.lua ./surround.lua ./cmp.lua ];
  };
}
