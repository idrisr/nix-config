{ pkgs, ... }:
let mpv-speed-script = pkgs.callPackage ./plugin.nix { };
in {
  programs.mpv = {
    enable = true;
    config = {
      hwdec = "vaapi";
      vo = "gpu";
      screenshot-template = "~/screenshots/%F-%wH.%wM.%wS";
      save-position-on-quit = true;
      keep-open = true;
      gpu-api = "opengl";
    };
    scripts = with pkgs.mpvScripts; [ mpv-speed-script ];
  };
}
