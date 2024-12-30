{
  config.programs.tmux = {
    aggressiveResize = true;
    baseIndex = 1;
    clock24 = true;
    customPaneNavigationAndResize = true;
    enable = true;
    escapeTime = 0;
    keyMode = "vi";
    prefix = "C-a";
    terminal = "screen-256color";
    tmuxp.enable = true;
    extraConfig = builtins.readFile ./tmux.conf;
  };
}
