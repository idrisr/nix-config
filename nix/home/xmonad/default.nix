{ pkgs, lib, specialArgs, ... }: {
  xresources.properties = {
    "Xft.dpi" = 180;
    "Xft.autohint" = 0;
    "Xft.hintstyle" = "hintfull";
    "Xft.hinting" = 1;
    "Xft.antialias" = 1;
    "Xft.rgba" = "rgb";
    "Xcursor*theme" = "Vanilla-DMZ-AA";
    "Xcursor*size" = 44;
  };

  home.packages = with pkgs; [
    dialog # Dialog boxes on the terminal (to show key bindings)
    networkmanager_dmenu # networkmanager on dmenu
    networkmanagerapplet # networkmanager applet
    nitrogen # wallpaper manager
    xcape # keymaps modifier
    xorg.xkbcomp # keymaps modifier
    xorg.xmodmap # keymaps modifier
    xorg.xrandr # display manager (X Resize and Rotate protocol)
  ];

  xsession = {
    enable = false;

    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
      extraPackages = hp: [
        hp.dbus
        hp.monad-logger
        hp.xmonad-contrib

      ];
      config = ./config.hs;
    };
  };
}
