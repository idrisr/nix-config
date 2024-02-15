{
  config = {
    programs.emacs = {
      enable = true;
      extraConfig = builtins.readFile ./init.el;
      extraPackages = e: with e; [ haskell-mode evil ];
    };
  };
}
