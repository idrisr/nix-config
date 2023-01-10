{ pkgs, config, ... }: {
  programs.fzf = {
    enable = true;

    changeDirWidgetCommand = "fd --type d";
    changeDirWidgetOptions = [ "--preview 'tree -c {} | head -200'" ];
    defaultCommand = "fd --type f";
    defaultOptions = [ "--height 100%" "--border" ];
    enableZshIntegration = true;
    fileWidgetCommand = "fd --type f";
    fileWidgetOptions = [ "--preview 'bat {}'" ];
  };
}
