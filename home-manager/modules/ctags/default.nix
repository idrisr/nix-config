{ pkgs, ... }: {
  config = {
    xdg.configFile."ctags/zettel.ctags".source = ./zettel.ctags;
    home.packages = [ pkgs.universal-ctags ];
  };
}
