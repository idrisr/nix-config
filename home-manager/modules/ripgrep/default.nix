{
  config = {
    programs.ripgrep = {
      enable = true;
      arguments = [
        "--max-columns=150"
        "--max-columns-preview"
        "--smart-case"
        "--hidden"
        "--glob=!.git/"
      ];
    };
  };
}
