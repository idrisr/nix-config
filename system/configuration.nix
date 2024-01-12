{ pkgs, config, ... }: {
  imports = [ ./xmonad.nix ./xfce.nix ];

  config = {
    services = {
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
    };

    nixpkgs.config.allowUnfreePredicate = pkg:
      builtins.elem (pkgs.lib.getName pkg) [ "tesseract5" "transcribe" ];

    environment = {
      sessionVariables.DEFAULT_BROWSER = "${pkgs.qutebrowser}/bin/qutebrowser";
    };
  };
}
