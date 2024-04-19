{ lib, pkgs, ... }:
let
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
      y = builtins.concatStringsSep "\n" (map f [ ./vifmrc ]);
      x1 = (map mkLink [ "scope" "cleaner" ]);
      x2 = [{ "vifm/vifmrc".text = y; }];
    in lib.mkMerge (x1 ++ x2);
    home.packages = with pkgs; [ vifm-full libheif ];
  };
}
