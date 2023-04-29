{ config, ... }:
let
  tmuxConf = builtins.readFile ./tmux.conf;
  extraConf = if config.theme.color == "dark" then
    ''
      set status-style 'bg=colour0 fg=colour12'; set status-right "#[fg=12]%d-%b %I:%M%p"''
  else ''
    set status-style 'bg=colour6 fg=colour7'; set status-right "#[fg=7]%d-%b
    %I:%M%p"'';
in {
  config = {
    programs.tmux = {
      aggressiveResize = true;
      baseIndex = 1;
      clock24 = true;
      customPaneNavigationAndResize = true;
      enable = true;
      escapeTime = 0;
      keyMode = "vi";
      prefix = "C-b";
      terminal = "screen-256color";
      tmuxp.enable = true;
      extraConfig = builtins.concatStringsSep "\n" [ tmuxConf extraConf ];
    };
  };
}
