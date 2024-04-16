{ makeDesktopItem }:

makeDesktopItem {
  name = "my-script";
  exec = "books"; # better to use name from package
  desktopName = "books";
  genericName = "Library Browser";
  categories = [ "Utility" ];
  icon = "sage-notebook";
}
