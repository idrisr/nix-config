{
  config = {
    programs.emacs = {
      enable = false;
      extraConfig = builtins.readFile ./init.el;
      extraPackages = e: with e; [ direnv evil haskell-mode racket-mode ];
    };
  };
}
