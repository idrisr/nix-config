{ pkgs, lib, config, ... }: {
  imports = [ ./users.nix ./xmonad.nix ./xfce.nix ];

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
    };
    services = {
      tailscale = { enable = true; };
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
        allowSFTP = false;
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
    programs.zsh.enable = true;
    nixpkgs.config.allowUnfreePredicate = pkg:
      builtins.elem (pkgs.lib.getName pkg) [
        "tarsnap"
        "transcribe"
        "tesseract5"
        "vscode"
        "vscode-with-extensions"
        "vscode-extension-ms-vscode-remote-remote-ssh"
        "vscode-extension-ms-vscode-cpptools"
      ];
    environment = {
      sessionVariables.DEFAULT_BROWSER = "${pkgs.qutebrowser}/bin/qutebrowser";
      systemPackages = with pkgs; [
        awscost
        booknote
        dimensions
        epubthumb
        mdtopdf
        newcover
        pdftc
        roamamer
        seder
        transcribe
        vifm
        vim
        man-pages
        man-pages-posix
      ];
      variables = {
        MANPAGER = "nvim +Man!";
        EDITOR = "nvim";
        VISUAL = "nvim";
        PAGER = "";
        LC_ALL = "en_US.UTF-8";
        HYPHEN_INSENSITIVE = "true";
        FZF_ALT_C_OPTS = "--preview 'tree -c {}| head -200'";
        FZF_ALT_C_COMMAND = "fd --type d";
        FZF_CTRL_T_COMMAND = "fd --type f";
        FZF_CTRL_T_OPTS =
          "--preview 'bat --style=numbers --color=always --line-range :500 {}'";
        FZF_DEFAULT_OPTS = "--height 90 --border bottom";
        FZF_COMPLETION_TRIGGER = "**";
      };
    };
    system.stateVersion = "22.05";
  };
}
