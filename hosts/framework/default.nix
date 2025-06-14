{ pkgs, ... }: {
  imports = [ ./hardware-framework.nix ];
  config = {
    monitoring.enable = false;
    base.enable = true;
    borg-backup-client.enable = true;
    local.printer.enable = true;
    display.enable = true;
    nvr.enable = false;
    passkey.enable = true;
    virtualization.enable = true;
    environment = {
      systemPackages = with pkgs; [
        framework-tool
        intel-gpu-tools
        brightnessctl
        fprintd
        tree
        openssl
        vifm
      ];
      # variables = { QT_SCALE_FACTOR = "0.75"; };
    };
    profile = {
      dailydrive.enable = true;
      rofi-book-search.enable = true;
    };
  };
}
