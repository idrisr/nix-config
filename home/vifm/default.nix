{ lib, pkgs, config, ... }:
let
  vifm-color = if config.theme.color == "dark" then
    ./solarized-dark.vifm
  else
    ./solarized-light.vifm;
  f = builtins.readFile;
  mkLink = x: {
    "vifm/scripts/${x}" = {
      text = f ./scripts/${x};
      executable = true;
    };
  };
in {
  config = {
    xdg.configFile = let
      y = builtins.concatStringsSep "\n" (map f [ ./vifmrc vifm-color ]);
      x1 = (map mkLink [ "scope" "cleaner" ]);
      x2 = [{ "vifm/vifmrc".text = y; }];
    in lib.mkMerge (x1 ++ x2);
    home.packages = [ pkgs.vifm-full ];
  };
}
