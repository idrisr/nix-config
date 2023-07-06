{ config, ... }:
let
  browser = "org.qutebrowser.desktop";
  spreadsheet = "libreoffice-calc.desktop";
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
          "text/html" = browser;
          "x-scheme-handler/about" = browser;
          "x-scheme-handler/http" = browser;
          "x-scheme-handler/https" = browser;
          "x-scheme-handler/unknown" = browser;

          # "application/vnd.oasis.opendocument.spreadsheet" = spreadsheet;
        };
      };
    };
  };
}
