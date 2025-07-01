{ pkgs, ... }: {
  imports = [ ./hardware-framework.nix ];
  config = {
    my.base.enable = true;
    borg-backup-client.enable = true;
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
    # profile = {
    # dailydrive.enable = true;
    # rofi-book-search.enable = true;
    # };
  };
}
