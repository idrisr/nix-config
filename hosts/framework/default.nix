{ pkgs, ... }: {
  imports = [ ./hardware-framework.nix ];
  config = {
    monitoring.enable = true;
    base.enable = true;
    borg-backup-client.enable = true;
    display.enable = true;
    environment.systemPackages = with pkgs; [
      framework-tool
      intel-gpu-tools
      brightnessctl
    ];
    profile = {
      dailydrive.enable = true;
      rofi-book-search.enable = true;
    };
  };
}
