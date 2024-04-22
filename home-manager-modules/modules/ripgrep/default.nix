{ pkgs, ... }:
let ripgrepConf = pkgs.writeText "ripgrepConf" (builtins.readFile ./ripgreprc);
in {
  config.home = {
    packages = [ pkgs.ripgrep ];
    sessionVariables = { RIPGREP_CONFIG_PATH = "${ripgrepConf}"; };
  };
}
