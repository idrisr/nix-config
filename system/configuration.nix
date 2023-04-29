{ pkgs, lib, ... }:

{
  imports = [
    ./hardware-tower.nix
    ./users.nix
    ./xmonad.nix
    # ./gnome.nix
  ];

  config = {
    # microsoft-surface.ipts.enable = true;

    boot = {
      loader.systemd-boot.enable = true;
      loader.efi.canTouchEfiVariables = true;
      loader.efi.efiSysMountPoint = "/boot/efi";
      kernelParams = [ "i915.enable_rc6=1" "i915.enable_psr=0" ];
    };

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

      openssh = {
        enable = true;
        settings.PasswordAuthentication = false;
        settings.KbdInteractiveAuthentication = false;
      };

    };

    # Configure keymap in X11
    console.useXkbConfig = true;

    time.timeZone = "America/Chicago";
    i18n.defaultLocale = "en_US.utf8";
    services.printing.enable = true;
    sound.enable = true;
    hardware.pulseaudio.enable = false;

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
      systemPackages = with pkgs; [ vim sg3_utils ];
      variables = {
        EDITOR = "nvim";
        VISUAL = "nvim";
        PAGER = "";
      };
    };
    system.stateVersion = "22.05";
  };
}
