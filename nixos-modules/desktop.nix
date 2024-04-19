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
    services = {
      displayManager = {
        defaultSession = "none+xmonad";
        sddm = {
          enable = false;
          theme = "chili";
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
            config = ./config.hs;
          };
        };
        dpi = 267;
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
      systemPackages = with pkgs; [
        libsForQt5.qt5.qtquickcontrols2
        libsForQt5.qt5.qtgraphicaleffects
        sddm-chili-theme
        feh
      ];
    };
  };
}
