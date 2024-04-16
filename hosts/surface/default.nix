{
  imports = [ ./hardware-surface.nix ];
  config = {
    monitoring.enable = true;
    base.enable = true;
    borg-backup-client.enable = true;
    display.enable = true;
    profile = {
      dailydrive.enable = true;
      rofi-book-search.enable = true;
    };
  };
}
