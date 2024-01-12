{ pkgs, config, ... }: {

  config = {
    services = {
      xserver = {
        windowManager.xmonad = {
          enable = true;
          enableContribAndExtras = true;
          extraPackages = hp:
            with hp; [
              dbus
              monad-logger
              xmonad-contrib
              xmonad
            ];
        };
        desktopManager = {
          xterm.enable = false;
          xfce = {
            enable = true;
            noDesktop = false;
            enableXfwm = false;
          };
        };
        displayManager = { defaultSession = "xfce+xmonad"; };
        dpi = 267;
        enable = true;
        layout = "us";
        upscaleDefaultCursor = true;
        libinput = {
          enable = true;
          touchpad = {
            disableWhileTyping = true;
            naturalScrolling = true;
          };
        };
        xkbOptions = "caps:escape";
        exportConfiguration = true;
        xkbVariant = "";
      };
    };

    nixpkgs.config.allowUnfreePredicate = pkg:
      builtins.elem (pkgs.lib.getName pkg) [ "tesseract5" "transcribe" ];

    environment = {
      sessionVariables.DEFAULT_BROWSER = "${pkgs.qutebrowser}/bin/qutebrowser";
      variables = {
        # QT_AUTO_SCREEN_SET_FACTOR = "0";
        # QT_SCALE_FACTOR = "2";
        # QT_FONT_DPI = "96";
        # GDK_SCALE = "2";
        # GDK_DPI_SCALE = "0.5";
      };
    };
  };
}
