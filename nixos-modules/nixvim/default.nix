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
    ./fugitive.nix
    ./keymap.nix
    ./latex.nix
    ./lsp.nix
    ./oil.nix
    ./neo-tree.nix
    ./surround.nix
    ./vimrc.nix
    ./telescope.nix
  ];

  config.programs.nixvim = {
    enable = true;

    colorschemes.gruvbox.enable = true;
    extraPlugins = with pkgs.vimPlugins; [
      ale
      fzf-vim # switch to fzf-lua
      nerdcommenter
      pkgs.zettel # option or module in flake with other packages
      vim-colors-solarized
    ];

    extraConfigVim =
      concatFiles [ ./vimrc ./ale.vim ./fzf.vim ./nerdcommenter.vim ];
    extraConfigLua = concatFiles [ ./fzf.lua ./surround.lua ];
  };
}
