{
  imports = [ ./hardware-surface.nix ];
  config = {
    monitoring.enable = true;
    services.avahi.enable = true;
    base.enable = true;
    borg-backup-client.enable = true;
    display.enable = true;
    local.printer.enable = true;
    docker.enable = true; # for open-webui
    profile = {
      dailydrive.enable = true;
      rofi-book-search.enable = true;
    };
  };
}
