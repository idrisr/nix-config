{ lib, ... }: {
  config = {
    programs.zsh = {
      enable = true;
      plugins = [ ];

      initContent = lib.mkBefore (builtins.concatStringsSep "\n" [
        ''eval "$(direnv hook zsh)"''
        ''
          set incappendhistorytime
          set -o no_print_exit_value
          set -o posixcd
          set -o promptsubst
          set -o vi
          bindkey -s '^g' 'lg ^M'
          bindkey -s '^a' 'tmux attach || tmux ^M'
          bindkey -s '^z' 'exec zsh ^M'
          bindkey -s '^p' 'tmuxp load session.yaml ^M'
          bindkey -s '^f' 'vifm ^M'
          bindkey -r '^v'
          bindkey -r '^V'
          bindkey -r '^[v'
          bindkey -r '^[V'
          autoload -U edit-command-line
          zle -N edit-command-line
          bindkey -M vicmd v edit-command-line
        ''
      ]);

      history = {
        extended = true;
        expireDuplicatesFirst = true;
        size = 1000000;
        save = 1000000;
      };

      shellAliases = {
        fd = "fd --type d";
        ff = "fd --type f";
        ga = "git add";
        gb = "git branch";
        gc = "git commit";
        gco = "git checkout";
        gd = "git diff";
        gds = "git diff --staged";
        githome = ''cd "$(git rev-parse --show-toplevel)"'';
        gpl = "git pull";
        gs = "git status";
        gsp = "git status --porcelain";
        lg = "lazygit";
        l = "lsd -l";
        ne = "nix-instantiate --eval";
        v = "nvim";
      };

    };
  };
}
