{ pkgs, ... }:
let
  pkgIfExists = name: if builtins.hasAttr name pkgs then [ pkgs.${name} ] else [ ];
in
{
  home.packages =
    pkgIfExists "ouch"
    ++ pkgIfExists "pdftc"
    ++ pkgIfExists "poppler-utils";

  programs.yazi = {
    enable = true;
    shellWrapperName = "y";
    plugins = {
      ouch = pkgs.yaziPlugins.ouch;
    };
    settings = {
      mgr = {
        show_hidden = true;
        ratio = [ 1 3 3 ];
        preview.max_width = 1200;
        preview.max_height = 1000;
      };
      opener = {
        edit = [{ run = ''nvim "%s"''; block = true; }];
        mpv = [{ run = ''${pkgs.mpv}/bin/mpv "$@"''; orphan = true; }];
      };
      open.prepend_rules = [
        { url = "*.mkv"; use = "mpv"; }
        { url = "*.srt"; use = "edit"; }
      ];
      plugin.prepend_previewers = [
        { mime = "application/*zip"; run = "ouch"; }
        { mime = "application/x-tar"; run = "ouch"; }
        { mime = "application/x-7z-compressed"; run = "ouch"; }
      ];
    };
  };
}
