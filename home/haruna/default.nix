{ pkgs, ... }:
let harunaConf = builtins.readFile ./haruna.conf;
in {
  config = {
    xdg.configFile."haruna/haruna.conf".text = harunaConf;
    home.packages = [ pkgs.haruna ];
  };
}
