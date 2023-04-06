{
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
        bindkey -s '^h' '$HOME/dotfiles/nix/apply-user.sh ^M'
        bindkey -s '^f' 'vifm ^M'
        bindkey -s '^v' 'nvim ^M'
      '';

      enable = true;
      history.extended = true;
      enableSyntaxHighlighting = true;
      enableCompletion = true;

      shellAliases = {
        ff = "fd --type f";
        fd = "fd --type d";
        gb = "git branch";
        gs = "git status";
        gc = "git commit";
        gco = "git checkout";
        gpl = "git pull";
        gsp = "git status --porcelain";
        ne = "nix-instantiate --eval";
        lg = "lazygit";
        ll = "ls --color -la";
        l = "ls --color -la";
        v = "nvim";
        vifm = "/home/hippoid/dotfiles/nix/home/vifm/vifmub";
        githome = ''cd "$(git rev-parse --show-toplevel)"'';
      };

      oh-my-zsh.enable = true;
      oh-my-zsh.plugins = [ "git" ];

      initExtra = builtins.concatStringsSep "\n" [
        (builtins.readFile ./idris.zsh-theme)
        "bindkey -M vicmd v edit-command-line"
        ''eval "$(direnv hook zsh)"''

      ];

      envExtra = ''
        export MANPAGER='nvim +Man!'
        export LC_ALL=en_US.UTF-8
        export LANG=en_US.UTF-8
        export HYPHEN_INSENSITIVE="true"
        export PAGER=""
        export RIPGREP_CONFIG_PATH=$HOME/dotfiles/rg/ripgreprc
        export FZF_ALT_C_OPTS="--preview 'tree -c {}| head -200'"
        export FZF_ALT_C_COMMAND="fd --type d"
        export FZF_CTRL_T_COMMAND="fd --type f"
        export FZF_CTRL_T_OPTS="--preview 'bat --style=numbers --color=always --line-range :500 {}'"
        export FZF_DEFAULT_OPTS="--height 90 --border bottom"
        export FZF_COMPLETION_TRIGGER="**"
        export MYVIFMRC="/home/hippoid/dotfiles/nix/home/vifm/vifmrc"
        export VIFM="/home/hippoid/dotfiles/nix/home/vifm"
      '';
    };
  };
}
