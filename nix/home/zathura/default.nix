let
  extraConfig = ''
    set font 'monospace normal 14'
    set selection-clipboard clipboard
    set sandbox none
  '';
in {
  config = {
    programs.zathura = {
      enable = true;

      extraConfig = builtins.concatStringsSep "\n" [
        # (builtins.readFile ./zathurarc)
        extraConfig
      ];
    };
  };
}
