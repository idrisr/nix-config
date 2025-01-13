{ pkgs, ... }:
let mpv-speed-script = pkgs.callPackage ./plugin.nix { };
in {
  programs.mpv = {
    enable = true;
    config = {
      hwdec = "vaapi";
      vo = "gpu";
      screenshot-template = "~/screenshots/%F-%wH.%wM.%wS.png";
      save-position-on-quit = true;
      keep-open = true;
    };
    scripts = with pkgs.mpvScripts; [ mpv-speed-script ];
  };
}
