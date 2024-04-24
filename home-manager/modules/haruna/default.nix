{ pkgs, ... }: {
  config = {
    xdg.configFile."haruna/haruna.conf".text = builtins.readFile ./haruna.conf;
    home.packages = [ pkgs.haruna ];
  };
}
