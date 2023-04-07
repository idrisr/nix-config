{ pkgs, ... }:
# let mkLink = x: xdg.configFile."ctags/${x}.ctags".text = builtins.readFile ./${x}.ctags; in
{
  config = {
    # trying to abstract these two statements with mkLink
    xdg.configFile."ctags/zettel.ctags".text = builtins.readFile ./zettel.ctags;
    xdg.configFile."ctags/terraform.ctags".text =
      builtins.readFile ./terraform.ctags;

    home.packages = [ pkgs.universal-ctags ];
  };
}
