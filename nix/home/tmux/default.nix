{ config, lib, pkgs, ... }:
let tmuxConf = builtins.readFile ./tmux.conf;
in {

  programs.tmux = {
    aggressiveResize = true;
    baseIndex = 1;
    clock24 = true;
    customPaneNavigationAndResize = true;
    enable = true;
    escapeTime = 0;
    extraConfig = tmuxConf;
    keyMode = "vi";
    prefix = "C-b";
    terminal = "screen-256color";
    tmuxp.enable = true;
  };
}
