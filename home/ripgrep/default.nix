{ lib, pkgs, config, ... }:
let ripgrepconf = builtins.readFile ./ripgreprc;
in {
  options = { ripgreprc = lib.mkOption { type = lib.types.path; }; };

  config = {
    xdg.configFile.rcPath.text = ripgrepconf;
    home.packages = [ pkgs.ripgrep ];
    ripgreprc = config.xdg.configFile.rcPath.source;
  };
}
