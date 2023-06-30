final: prev: {
  zettel-plugin = with prev.pkgs;
    vimUtils.buildVimPluginFrom2Nix {
      pname = "vim-zettel";
      version = "2023-06-30";
      src = ../neovim/zettel;
    };
}
