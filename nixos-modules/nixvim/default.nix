{ pkgs, ... }:
let
  vimkind = pkgs.vimUtils.buildVimPlugin {
    pname = "one-small-step-for-vimkind";
    version = "2023-06-30";
    src = pkgs.fetchFromGitHub {
      repo = "one-small-step-for-vimkind";
      owner = "jbyuki";
      rev = "0dd306e68bf79b38cc01b15c22047e6a867df7de";
      sha256 = "sha256-G5soAD3+z7BOxMaZVLPBEHxNa2H3Jp+dqDwQDMAlx2k=";
    };
  };
  concatFiles = files:
    let
      j = map builtins.readFile files;
      k = builtins.concatStringsSep "\n" ([ " " ] ++ j);
    in k;
in {
  imports = [
    ./align.nix
    ./alpha.nix
    ./cmp.nix
    ./comment.nix
    ./conform.nix
    ./dap.nix
    ./fugitive.nix
    ./fzf.nix
    ./keymap.nix
    ./latex.nix
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
    ./ultisnips.nix # move to other snip thing
    ./vimrc.nix
    ./whichkey.nix
  ];

  config.programs.nixvim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    colorschemes.gruvbox.enable = true;

    extraPlugins = with pkgs.vimPlugins; [
      fzf-vim # switch to fzf-lua?
      nvim-dap-ui
      vimkind
      pkgs.zettel
      telescope_hoogle
    ];
    extraConfigVim = concatFiles [ ./vimrc ];
    extraConfigLua = concatFiles [
      ./init.lua
      ./cmp.lua
      ./surround.lua
      ./vimkind.lua
      ./lua-plugin/telescope.lua
    ];
  };
}
