{
  config = {
    services = {
      xserver = {
        enable = true;
        dpi = 267;
        displayManager.defaultSession = "xfce+xmonad";
        exportConfiguration = true;
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
