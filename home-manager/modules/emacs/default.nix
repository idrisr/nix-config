{
  config = {
    programs.emacs = {
      enable = true;
      extraConfig = builtins.readFile ./init.el;
      extraPackages = e:
        with e; [
          direnv
          evil
          fuzzy-finder
          haskell-mode
          nix-mode
          obsidian
          prolog-mode
          quack
          racket-mode
          zerodark-theme
          zoxide
        ];
    };
  };
}
