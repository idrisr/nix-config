{ config, lib, pkgs, ... }:

let cfg = config.my.base;
in {
  imports = [ ./users.nix ];

  options = {
    my.base = {
      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = lib.mdDoc ''
          direct transfer of the old base module.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    boot.loader.systemd-boot.configurationLimit = 10;
    nix = {
      package = pkgs.nixVersions.stable;
      settings = {
        experimental-features = [ "nix-command" "flakes" ];
        trusted-users = [ "root" "hippoid" ];
        auto-optimise-store = true;
        allow-import-from-derivation = true;
      };
      gc = {
        automatic = true;
        dates = "daily";
        options = "--delete-older-than 7d";
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

    systemd.services.NetworkManager-wait-online.enable = false;

    # Configure keymap in X11
    console.useXkbConfig = true;
    time.timeZone = "America/Chicago";

    programs = {
      zsh.enable = true;
      fuse.userAllowOther = true;
    };

    environment = {
      systemPackages = with pkgs; [ vim man-pages man-pages-posix ];
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
