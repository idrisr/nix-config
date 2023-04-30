{ pkgs, ... }: {
  config = {
    services = {
      xserver = {
        windowManager.xmonad = {
          enable = true;
          enableContribAndExtras = true;
          extraPackages = hp: [
            hp.dbus
            hp.monad-logger
            hp.xmonad-contrib
            hp.xmonad

          ];
        };
      };
    };
  };
}
