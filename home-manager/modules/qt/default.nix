{ pkgs, ... }: {
  config = {
    qt = {
      enable = true;
      # platformTheme.name = "gtk";
      style = {
        # name = "adwaita-dark";
        package = pkgs.adwaita-qt;
      };
    };
  };
}
