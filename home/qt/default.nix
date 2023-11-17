{ config, pkgs, ... }: {
  config = {
    qt = {
      enable = true;
      platformTheme = "gtk";
      style = {
        name = "adwaita-dark";
        package = pkgs.adwaita-qt;
      };
    };

    gtk = {
      enable = true;
      # cursorTheme = { };
      # theme = { };
      # iconTheme = {
      # };
    };
  };
}
