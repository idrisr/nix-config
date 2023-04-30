{
  config = {
    services = {
      xserver = {
        enable = true;
        displayManager.defaultSession = "xfce+xmonad";
        # displayManager.defaultSession = "xfce";
        desktopManager = {
          xterm.enable = false;
          xfce = {
            enable = true;
            noDesktop = false;
            enableXfwm = false;
          };
        };

        layout = "us";
        xkbOptions = "caps:escape";
        xkbVariant = "";
      };

    };
  };
}
