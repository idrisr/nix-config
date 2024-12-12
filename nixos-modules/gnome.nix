{
  config = {
    services = {
      xserver = {

        displayManager.gdm.enable = true;
        desktopManager.gnome.enable = true;

        enable = true;
        layout = "us";
        xkbVariant = "";
      };
    };
  };
}
