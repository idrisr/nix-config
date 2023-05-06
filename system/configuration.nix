{ pkgs, lib, config, ... }:

{
  imports = [ ./users.nix ./xmonad.nix ./xfce.nix ./virtualization ./mymodule ];

  config = {
    nix = {
      package = pkgs.nixFlakes;
      extraOptions = ''
        experimental-features = nix-command flakes
      '';
      settings.trusted-users = [ "root" "hippoid" ];

      gc = {
        automatic = true;
        options = "--delete-older-than 30d";
      };
    };

    security = {
      sudo.wheelNeedsPassword = false;
      rtkit.enable = true;
    };

    services = {
      tailscale = { enable = true; };
      upower = { enable = true; };
      xserver = {
        enable = true;
        layout = "us";
        upscaleDefaultCursor = true;

        libinput = {
          enable = true;
          touchpad.disableWhileTyping = true;
          touchpad.naturalScrolling = true;
        };
        xkbOptions = "caps:escape";
      };

      dbus = {
        enable = true;
        packages = [ pkgs.dconf ];
      };

      openssh = {
        enable = true;
        settings = {
          PasswordAuthentication = false;
          KbdInteractiveAuthentication = false;
          X11Forwarding = true;
        };
      };
    };

    # Configure keymap in X11
    console.useXkbConfig = true;
    time.timeZone = "America/Chicago";
    i18n.defaultLocale = "en_US.utf8";
    programs.zsh.enable = true;

    nixpkgs.config.allowUnfreePredicate = pkg:
      builtins.elem (pkgs.lib.getName pkg) [
        "tarsnap"
        "vscode"
        "vscode-with-extensions"
        "vscode-extension-ms-vscode-remote-remote-ssh"
        "vscode-extension-ms-vscode-cpptools"
      ];

    environment = {
      systemPackages = with pkgs; [ vifm vim sg3_utils ];
      variables = {
        EDITOR = "nvim";
        VISUAL = "nvim";
        PAGER = "";
      };
    };

    system.stateVersion = "22.05";
  };
}
