{ pkgs, config, ... }: {
  config = {
    programs.zsh = {
      initExtraFirst = ''
        set incappendhistorytime
        set -o no_print_exit_value
        set -o posixcd
        set -o promptsubst
        set -o vi
        bindkey -s '^l' 'dirs -v ^M'
        bindkey -s '^a' 'tmux attach || tmux ^M'
        bindkey -s '^z' 'exec zsh ^M'
        bindkey -s '^p' 'tmuxp load ~/tmuxp/session.yaml ^M'
        bindkey -s '^f' 'vifm ^M'
        bindkey -s '^v' 'nvim ^M'
      '';
      # bindkey -s '^h' '$HOME/dotfiles/apply-user.sh light ^M'
      # bindkey -s '^j' '$HOME/dotfiles/apply-user.sh dark ^M'

      enable = true;
      history.extended = true;
      enableSyntaxHighlighting = true;
      enableCompletion = true;

      shellAliases = {
        cb = "chatblade";
        fd = "fd --type d";
        ff = "fd --type f";
        gb = "git branch";
        gc = "git commit";
        gco = "git checkout";
        gd = "git diff";
        githome = ''cd "$(git rev-parse --show-toplevel)"'';
        gpl = "git pull";
        gs = "git status";
        gsp = "git status --porcelain";
        lg = "lazygit";
        ll = "ls --color -la";
        l = "ls --color -la";
        ne = "nix-instantiate --eval";
        vifm = "/home/hippoid/dotfiles/home/vifm/vifmub";
        v = "nvim";
      };

      oh-my-zsh.enable = true;
      oh-my-zsh.plugins = [ "git" ];

      initExtra = builtins.concatStringsSep "\n" [
        (builtins.readFile ./idris.zsh-theme)
        "bindkey -M vicmd v edit-command-line"
        ''eval "$(direnv hook zsh)"''

      ];

      envExtra = ''
        export RIPGREP_CONFIG_PATH="${config.ripgreprc}"
      '';
    };
  };
}
