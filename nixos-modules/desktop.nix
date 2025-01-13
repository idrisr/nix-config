{ config, pkgs, lib, ... }:
let cfg = config.display;
in {
  options = {
    display = {
      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = lib.mdDoc ''
          Enable Graphical Display
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    programs.i3lock.enable = true;
    programs.droidcam.enable = true;
    services = {
      displayManager = {
        defaultSession = "none+xmonad";
        sddm = {
          enable = false;
          theme = "chili";
        };
      };
      libinput = {
        enable = true;
        touchpad = {
          disableWhileTyping = true;
          naturalScrolling = true;
        };
      };
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
            config = ../xmonad/Main.hs;
          };
        };
        dpi = 267;
        xkb = {
          layout = "us";
          variant = "";
        };
        exportConfiguration = true;
      };
    };

    environment = {
      sessionVariables = {
        DEFAULT_BROWSER = "${pkgs.qutebrowser}/bin/qutebrowser";
      };
      systemPackages = with pkgs; [
        libsForQt5.qt5.qtquickcontrols2
        libsForQt5.qt5.qtgraphicaleffects
        sddm-chili-theme
        feh
        devenv
      ];
    };
  };
}
