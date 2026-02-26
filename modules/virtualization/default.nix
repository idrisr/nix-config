{ pkgs, lib, config, ... }:
with lib;
let cfg = config.virtualization;
in {

  options = {
    virtualization = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = lib.mdDoc ''
          Enable local qemu stuff.
        '';
      };
    };
  };
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      adwaita-icon-theme
      libosinfo
      libvirt-glib
      spice
      spice-gtk
      spice-protocol
      virt-manager
      virt-viewer
      win-spice
      virtio-win
    ];

    programs.dconf.enable = true;
    users.groups.libvirtd.members = [ "hippoid" ];

    # Manage the virtualisation services
    virtualisation = {
      libvirtd = {
        enable = true;
        qemu = {
          swtpm.enable = true;
        };
      };
      spiceUSBRedirection.enable = true;
    };
    services.spice-vdagentd.enable = true;
  };
}
