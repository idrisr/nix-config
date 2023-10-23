{ pkgs, config, ... }: {
  config = {
    programs.zsh = {
      enable = true;
      plugins = [ ];

      initExtraFirst = ''
        set incappendhistorytime
        set -o no_print_exit_value
        set -o posixcd
        set -o promptsubst
        set -o vi
        bindkey -s '^l' 'lg ^M'
        bindkey -s '^a' 'tmux attach || tmux ^M'
        bindkey -s '^z' 'exec zsh ^M'
        bindkey -s '^p' 'tmuxp load ~/tmuxp/session.yaml ^M'
        bindkey -s '^f' 'vifm ^M'
        bindkey -s '^v' 'nvim ^M'
        autoload -U edit-command-line
        zle -N edit-command-line
        bindkey -M vicmd v edit-command-line
      '';

      history = {
        extended = true;
        expireDuplicatesFirst = true;
        size = 1000000;
        save = 1000000;
      };

      shellAliases = {
        cb = "chatblade";
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
        ll = "ls --color -la";
        l = "ls --color -la";
        ne = "nix-instantiate --eval";
        vifm = "/home/hippoid/dotfiles/home/vifm/vifmub";
        v = "nvim";
      };

      initExtra =
        builtins.concatStringsSep "\n" [ ''eval "$(direnv hook zsh)"'' ];

      envExtra = ''
        export RIPGREP_CONFIG_PATH="${config.ripgreprc}"
        export VIFM="/home/hippoid/.config/vifm";
      '';
    };
  };
}
