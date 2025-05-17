{ pkgs, ... }: {
  config.environment = {
    sessionVariables = { NH_FLAKE = "/home/hippoid/dotfiles"; };
    systemPackages = with pkgs; [ nh nvd nix-output-monitor ];
  };
}
