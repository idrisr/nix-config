let
  extraConfig = ''
    set selection-clipboard clipboard
    set sandbox none
    set guioptions none
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
