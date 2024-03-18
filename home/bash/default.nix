{
  config = {
    programs.bash = {
      initExtraFirst = ''
        set -o vi
      '';

      enable = true;
      history.extended = true;
      enableSyntaxHighlighting = true;
      enableCompletion = true;
    };
  };
}
