{ pkgs, ... }:
# let mkLink = x: { "ctags/${x}.ctags".text = builtins.readFile ./${x}.ctags; };
{
  config = {
    xdg.configFile."ctags/zettel.ctags".text = builtins.readFile ./zettel.ctags;
    home.packages = [ pkgs.universal-ctags ];
  };
}
