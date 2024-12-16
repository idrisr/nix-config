{ pkgs, ... }:
let
  concatFiles = files:
    let
      j = map builtins.readFile files;
      k = builtins.concatStringsSep "\n" ([ " " ] ++ j);
    in k;
in {
  imports = [
    ./align.nix
    ./alpha.nix
    ./autocommand.nix
    ./autosession.nix
    ./cmp.nix
    ./comment.nix
    ./conform.nix
    ./dap.nix
    ./fugitive.nix
    ./fzf.nix
    ./keymap.nix
    ./latex.nix
    ./lean
    ./lsp.nix
    ./neo-tree.nix
    ./notify.nix
    ./obsidian.nix
    ./oil.nix
    ./ollama.nix
    ./persistence.nix
    ./surround.nix
    ./telescope.nix
    ./toggleterm.nix
    ./transparent.nix
    ./trouble.nix
    ./ultisnips.nix # move to other snip thing
    ./vimrc.nix
    ./whichkey.nix
  ];

  config.programs.nixvim = {
    enable = true;
    viAlias = true;
    vimAlias = true;

    extraPlugins = with pkgs.vimPlugins; [
      fzf-vim # switch to fzf-lua?
      nvim-dap-ui
      telescope_hoogle
      outline-nvim
      nvim-lilypond-suite
      kmonad-vim
      pkgs.zettel
    ];

    extraConfigVim = concatFiles [ ./vimrc ];
    extraConfigLua = concatFiles [
      ./init.lua
      ./cmp.lua
      ./surround.lua
      ./debug-adapter.lua
      ./lua-plugin/telescope.lua
    ];
  };
}
