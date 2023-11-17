{ config, lib, pkgs, ... }: {
  options = {
    theme = {
      enable = lib.mkEnableOption "theme";
      color = lib.mkOption {
        type = lib.types.str;
        default = "dark";
      };
    };
  };
  config.theme.color = "dark";
}
