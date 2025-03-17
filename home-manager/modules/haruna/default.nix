{ pkgs, ... }: {
  config = {
    xdg.configFile."haruna/haruna.conf".source = ./haruna.conf;
    home.packages = [ pkgs.haruna ];
  };
}
