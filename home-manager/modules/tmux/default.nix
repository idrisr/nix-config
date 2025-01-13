{ pkgs, ... }: {
  config.programs.tmux = {
    aggressiveResize = true;
    baseIndex = 1;
    clock24 = true;
    customPaneNavigationAndResize = true;
    enable = true;
    escapeTime = 0;
    keyMode = "vi";
    prefix = "C-h";
    terminal = "screen-256color";
    tmuxp.enable = true;
    extraConfig = builtins.readFile ./tmux.conf;
    plugins = [
      {
        plugin = pkgs.tmuxPlugins.resurrect;
        extraConfig = "set -g @resurrect-strategy-nvim 'session'";
      }
      pkgs.tmuxPlugins.resurrect
      # {
      # # plugin = pkgs.tmuxPlugins.catppuccin;
      # # extraConfig =
      # # ''set -ag status-right "#{E:@catppuccin_status_session}"'';
      # }
      pkgs.tmuxPlugins.continuum
      pkgs.tmuxPlugins.tmux-fzf
    ];
  };
}
