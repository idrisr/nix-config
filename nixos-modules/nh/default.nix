{ pkgs, ... }: {
  config.environment = {
    sessionVariables = { FLAKE = "/home/hippoid/dotfiles"; };
    systemPackages = with pkgs; [ nh nvd nix-output-monitor ];
  };
}
