let
  extraConfig = ''
    set synctex true
    set synctex-editor-command "nvim --remote-silent +%{line} %{input}"
    set selection-clipboard clipboard
    set sandbox none
    set guioptions none
    map D set first-page-column 1:1
    map E set first-page-column 1:2
  '';
in {
  config = {
    programs.zathura = {
      enable = true;
      extraConfig = extraConfig;
    };
  };
}
