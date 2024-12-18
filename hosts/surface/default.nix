{
  imports = [ ./hardware-surface.nix ];
  config = {
    monitoring.enable = true;
    services.avahi.enable = false;
    base.enable = true;
    borg-backup-client.enable = true;
    display.enable = true;
    local.printer.enable = false;
    docker.enable = false; # for open-webui
    profile = {
      dailydrive.enable = true;
      rofi-book-search.enable = true;
    };
  };
}
