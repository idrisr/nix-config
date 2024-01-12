{ config, pkgs, ... }: {
  imports = [ ./users.nix ];
  config = {
    boot.loader.systemd-boot.configurationLimit = 10;
    nix = {
      package = pkgs.nixFlakes;
      settings = {
        experimental-features = [ "nix-command" "flakes" ];
        trusted-users = [ "root" "hippoid" ];
        auto-optimise-store = true;
      };
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 1w";
      };
    };

    security = {
      sudo.wheelNeedsPassword = false;
      rtkit.enable = true;
      polkit.enable = true;
    };

    services = {
      tailscale = { enable = true; };
      dbus = {
        enable = true;
        packages = [ pkgs.dconf ];
      };
      openssh = {
        enable = true;
        settings = {
          PasswordAuthentication = false;
          KbdInteractiveAuthentication = false;
          X11Forwarding = false;
        };
      };
    };

    # Configure keymap in X11
    console.useXkbConfig = true;
    time.timeZone = "America/Chicago";
    i18n.defaultLocale = "en_US.utf-8";

    programs = {
      zsh.enable = true;
      fuse.userAllowOther = true;
    };

    environment = {
      systemPackages = with pkgs; [ vifm vim man-pages man-pages-posix ];
      variables = {
        # QT_AUTO_SCREEN_SET_FACTOR = "0";
        # QT_SCALE_FACTOR = "2";
        # QT_FONT_DPI = "96";
        # GDK_SCALE = "2";
        # GDK_DPI_SCALE = "0.5";

        MANPAGER = "nvim +Man!";
        EDITOR = "nvim";
        VISUAL = "nvim";
        PAGER = "";
        LC_ALL = "en_US.UTF-8";
        HYPHEN_INSENSITIVE = "true";
      };
    };
  };
}
