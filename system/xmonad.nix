{ pkgs, ... }: {
  config = {
    services = {
      xserver = {
        windowManager.xmonad = {
          enable = true;
          enableContribAndExtras = true;
          extraPackages = hp:
            with hp; [
              dbus
              monad-logger
              xmonad-contrib
              xmonad
            ];
        };
      };
    };
  };
}
