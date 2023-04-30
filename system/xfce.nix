{
  config = {
    services = {
      xserver = {
        desktopManager = {
          enable = true;
          xfce = {
            enable = true;
            noDesktop = true;
            enableXfwm = false;
          };
        };

        layout = "us";
        xkbOptions = "caps:escape";
        xkbVariant = "";
      };
      displayManager.defaultSession = "xfce+xmonad";

    };
  };
}
