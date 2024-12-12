{ pkgs, ... }: {
  imports = [ ./hardware-framework.nix ];
  config = {
    monitoring.enable = true;
    base.enable = true;
    borg-backup-client.enable = true;
    display.enable = true;
    profile.dailydrive.enable = true;
    environment.systemPackages = [ pkgs.framework-tool ];
  };
}
