{
  config = {
    programs.emacs = {
      enable = true;
      extraConfig = builtins.readFile ./init.el;
      extraPackages = e: with e; [ direnv evil haskell-mode racket-mode ];
    };
  };
}
