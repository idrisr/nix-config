{ pkgs, ... }: {
  config = {
    services = {
      gnome.gnome-keyring.enable = true;
      upower.enable = true;

      dbus = {
        enable = true;
        packages = [ pkgs.dconf ];
      };

      xserver = {
        enable = true;
        layout = "us";

        libinput = {
          enable = true;
          touchpad.disableWhileTyping = true;
          touchpad.naturalScrolling = true;
        };

        displayManager.defaultSession = "none+xmonad";

        windowManager.xmonad = {
          enable = true;
          enableContribAndExtras = true;
          extraPackages = hp: [ hp.dbus hp.monad-logger hp.xmonad-contrib ];
        };

        xkbOptions = "caps:escape";
      };
    };

    hardware.bluetooth.enable = true;
    services.blueman.enable = true;
    systemd.services.upower.enable = true;
  };
}
