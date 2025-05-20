{ pkgs, ... }: {
  imports = [ ./hardware-framework.nix ];
  config = {
    monitoring.enable = false;
    base.enable = true;
    borg-backup-client.enable = true;
    local.printer.enable = true;
    display.enable = true;
    nvr.enable = false;
    virtualization.enable = true;
    environment.systemPackages = with pkgs; [
      framework-tool
      intel-gpu-tools
      brightnessctl
      fprintd
      tree
      openssl
      vifm
    ];
    profile = {
      dailydrive.enable = true;
      rofi-book-search.enable = true;
    };
  };
}
