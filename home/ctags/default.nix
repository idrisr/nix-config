{ pkgs, lib, ... }:
let mkLink = x: { "ctags/${x}.ctags".text = builtins.readFile ./${x}.ctags; };
in {
  config = {
    xdg.configFile = lib.mkMerge (map mkLink [ "zettel" "terraform" ]);
    home.packages = [ pkgs.universal-ctags ];
  };
}
