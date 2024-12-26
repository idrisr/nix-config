{ config, ... }:
let
  qute = "org.qutebrave.qutebrave.desktop";
  brave = "brave-brave.desktop";
  # spreadsheet = "libreoffice-calc.desktop";
  pdf = "org.pwmt.zathura.desktop";
in {
  config = {
    xdg = {
      enable = true;

      userDirs = {
        createDirectories = true;
        enable = true;
        documents = "${config.home.homeDirectory}/documents";
        download = "${config.home.homeDirectory}/downloads";
        music = "${config.home.homeDirectory}/music";
        pictures = "${config.home.homeDirectory}/pictures";
        videos = "${config.home.homeDirectory}/videos";
        desktop = "${config.home.homeDirectory}/desktop";
        templates = "${config.home.homeDirectory}/templates";
      };

      mimeApps = {
        enable = true;
        defaultApplications = {
          "application/pdf" = pdf;
          "text/html" = brave;
          "x-scheme-handler/about" = brave;
          "x-scheme-handler/http" = brave;
          "x-scheme-handler/https" = brave;
          "x-scheme-handler/unknown" = brave;
        };
      };
    };
  };
}
