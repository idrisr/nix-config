{ pkgs, ... }: {
  imports = [ ./hardware-framework.nix ];
  config = {
    monitoring.enable = false;
    base.enable = true;
    borg-backup-client.enable = true;
    display.enable = true;
    virtualization.enable = true;
    environment.systemPackages = with pkgs; [
      framework-tool
      intel-gpu-tools
      brightnessctl
      fprintd
    ];
    profile = {
      dailydrive.enable = true;
      rofi-book-search.enable = true;
    };
  };
}
