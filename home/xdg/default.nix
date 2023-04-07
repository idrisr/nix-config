{ config, ... }:
let
  browser = "org.qutebrowser.qutebrowser.desktop";
  spreadsheet = "libreoffice-calc.desktop";
  pdf = "org.pwmt.zathura.desktop";
in {
  config = {
    xdg = {
      enable = true;

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
