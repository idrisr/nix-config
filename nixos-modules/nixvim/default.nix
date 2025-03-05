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
    ./avante.nix
    ./cmp.nix
    ./comment.nix
    ./conform.nix
    ./cornelis.nix
    ./dap.nix
    ./emmet.nix
    ./fugitive.nix
    ./fzf.nix
    ./keymap.nix
    ./latex.nix
    ./lean
    ./lsp.nix
    ./neoscroll.nix
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
      img-clip-nvim
      kmonad-vim
      nvim-dap-ui
      nvim-lilypond-suite
      outline-nvim
      pkgs.zettel
      telescope_hoogle
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
