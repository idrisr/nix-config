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

  xdg.configFile."vifm/scripts/scope".text = builtins.readFile ./scripts/scope;
  xdg.configFile."vifm/scripts/cleaner".text =
    builtins.readFile ./scripts/cleaner;
  xdg.configFile."vifm/scripts/scope".executable = true;
  xdg.configFile."vifm/scripts/cleaner".executable = true;
}
