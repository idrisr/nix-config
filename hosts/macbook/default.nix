{ pkgs, ... }:
{

  services.prometheus.exporters.node = {
    enable = true;
  };

  environment.systemPackages = with pkgs; [
    htop
    jq
    ripgrep
  ];
}
