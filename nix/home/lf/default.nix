{ config, pkgs, ... }: {
  programs.lf = {
    enable = true;

    extraConfig = builtins.readFile ./lfrc;

  };
}
