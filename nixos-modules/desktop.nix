{ inputs, config, pkgs, lib, ... }:
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
    programs.droidcam.enable = false;
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

    specialisation.hyprland = {
      inheritParentConfig = true;
      configuration = {
        programs.hyprland = {
          enable = true;
          package =
            inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
          # make sure to also set the portal package, so that they are in sync
          portalPackage =
            inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
        };
      };
    };

    specialisation.gnome.configuration = {
      services.xserver.windowManager.xmonad.enable = lib.mkForce false;
      services.xserver.desktopManager.gnome.enable = true;
      services.displayManager.defaultSession = lib.mkForce "gnome";
    };

    specialisation.plasma.configuration = {
      services.xserver.windowManager.xmonad.enable = lib.mkForce false;
      services.xserver.desktopManager.plasma5.enable = true;
      services.displayManager.defaultSession = lib.mkForce "plasma";
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
