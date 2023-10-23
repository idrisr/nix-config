{
  config = {
    home.sessionVariables = { FZF_COMPLETION_TRIGGER = "**"; };
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
        # "--bind 'enter:become(nvim {+})'"
        "--multi"
      ];

      defaultCommand = "fd --type f";
      defaultOptions = [
        "--exact"
        "--track"
        "--height 60%"
        "--bind 'ctrl-/:toggle-preview'"
        "--bind 'ctrl-u:page-up'"
        "--bind 'ctrl-d:page-down'"
        "--bind 'ctrl-alt-u:preview-page-up'"
        "--bind 'ctrl-alt-d:preview-page-down'"
      ];
      historyWidgetOptions = [
        "--exact"
        "--reverse"
        "--sort"
        "--color header:italic"

      ];
      tmux = {
        enableShellIntegration = true;
        shellIntegrationOptions = [
          "-p"
          "-w 95%"
          "-h 95%"

        ];
      };
    };
  };
}
