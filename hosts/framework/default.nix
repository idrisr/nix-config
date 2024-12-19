{ pkgs, ... }: {
  imports = [ ./hardware-framework.nix ];
  config = {
    monitoring.enable = true;
    base.enable = true;
    borg-backup-client.enable = true;
    display.enable = true;
    environment.systemPackages = [ pkgs.framework-tool ];
    profile = {
      dailydrive.enable = true;
      rofi-book-search.enable = true;
    };
  };
}
