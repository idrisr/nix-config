{ config, lib, pkgs, ... }:

let cfg = config.base;
in {
  imports = [ ./users.nix ];

  options = {
    base = {
      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = lib.mdDoc ''
          Direct transfer of the old base module.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
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
      iotop.enable = true;
    };

    environment = {
      systemPackages = with pkgs; [ vifm vim man-pages man-pages-posix ];
      variables = {
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
