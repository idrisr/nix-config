{ pkgs, ... }:
{

  services.prometheus.exporters.node = {
    enable = true;
  };

  system.defaults.finder = {
    AppleShowAllExtensions = true;
    AppleShowAllFiles = false;
    FXEnableExtensionChangeWarning = true;
    FXPreferredViewStyle = "Nlsv";
    ShowPathbar = true;
    ShowStatusBar = true;
    _FXSortFoldersFirst = true;
  };

  nix.enable = false;

  environment.systemPackages = with pkgs; [
    htop
    jq
    ripgrep
  ];
}
