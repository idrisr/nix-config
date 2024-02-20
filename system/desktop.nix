{ pkgs, ... }: {
  config = {
    programs.i3lock.enable = true;
    services = {
      xserver = {
        enable = true;
        windowManager = {
          xmonad = {
            enable = true;
            enableContribAndExtras = true;
            extraPackages = hp:
              with hp; [
                dbus
                monad-logger
                xmonad-contrib
                xmonad
              ];
            config = ./config.hs;
          };
        };
        displayManager = { defaultSession = "none+xmonad"; };
        dpi = 267;
        upscaleDefaultCursor = true;
        libinput = {
          enable = true;
          touchpad = {
            disableWhileTyping = true;
            naturalScrolling = true;
          };
        };
        xkb = {
          options = "caps:escape";
          layout = "us";
          variant = "";
        };
        exportConfiguration = true;
      };
    };

    nixpkgs.config.allowUnfreePredicate = pkg:
      builtins.elem (pkgs.lib.getName pkg) [ "tesseract5" "transcribe" ];

    environment = {
      sessionVariables = {
        DEFAULT_BROWSER = "${pkgs.qutebrowser}/bin/qutebrowser";
      };
    };
  };
}
