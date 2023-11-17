{
  config = {
    services = {
      xserver = {
        enable = true;
        dpi = 267;
        displayManager.defaultSession = "xfce+xmonad";
        exportConfiguration = true;
        desktopManager = {
          xterm.enable = false;
          xfce = {
            enable = true;
            noDesktop = false;
            enableXfwm = false;
          };
        };
        layout = "us";
        xkbVariant = "";
      };
    };
  };
}
