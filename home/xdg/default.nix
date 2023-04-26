{ config, ... }:
let
  browser = "org.qutebrowser.qutebrowser.desktop";
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
      };

      mimeApps = {
        enable = true;
        defaultApplications = {
          "x-scheme-handler/http" = browser;
          "x-scheme-handler/https" = browser;
          "text/html" = browser;
          "application/pdf" = pdf;
          # "application/vnd.oasis.opendocument.spreadsheet" = spreadsheet;
        };
      };
    };
  };
}
