{ config, pkgs, lib, ... }:
let
  vifm-color = if config.theme.color == "dark" then
    ./solarized-dark.vifm
  else
    ./solarized-light.vifm;
in {
  xdg.configFile."vifm/vifmrc".text = builtins.concatStringsSep "\n" [
    (builtins.readFile ./vifmrc)
    (builtins.readFile vifm-color)

  ];

}
