{
  config = {
    programs.fzf = {
      enable = true;
      enableZshIntegration = true;

      changeDirWidgetCommand = "fd --type d";
      changeDirWidgetOptions = [
        "--exact"
        "--preview 'tree -c {} | head -200'"

      ];

      fileWidgetCommand = "fd --type f";
      fileWidgetOptions = [
        "--preview 'bat --style=numbers --color=always --line-range :500 {}'"
        "--exact"
      ];

      defaultCommand = "fd --type f";
      defaultOptions = [ "--height 60%" "--border" ];
      historyWidgetOptions = [ "--exact" "--sort" "--reverse" ];

    };
    home.sessionVariables = { FZF_COMPLETION_TRIGGER = "**"; };
  };
}
