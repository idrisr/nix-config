{ pkgs, ... }:
{

  services.prometheus.exporters.node = {
    enable = true;
  };
  nix.enable = false;

  environment.systemPackages = with pkgs; [
    htop
    jq
    ripgrep
  ];
}
