{ pkgs, ... }: {
  config.programs.nixvim = {
    extraPlugins = [ pkgs.vimPlugins.nerdcommenter ];

    globals = {
      NERDSpaceDelims = 1;
      NERDCompactSexyComs = 1;
      NERDCustomDelimiters = { lhaskell = { "left" = ">"; }; };
    };
  };
}
