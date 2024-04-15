{ pkgs, ... }: {
  config = {
    environment.systemPackages = with pkgs; [
      gnome.adwaita-icon-theme
      libosinfo
      libvirt-glib
      spice
      spice-gtk
      spice-protocol
      virt-manager
      virt-viewer
      win-spice
      win-virtio
    ];

    programs.dconf.enable = true;
    users.users.hippoid.extraGroups = [ "libvirtd" ];

    # Manage the virtualisation services
    virtualisation = {
      libvirtd = {
        enable = true;
        qemu = {
          swtpm.enable = true;
          ovmf.enable = true;
          ovmf.packages = [ pkgs.OVMFFull.fd ];
        };
      };
      spiceUSBRedirection.enable = true;
    };
    services.spice-vdagentd.enable = true;
  };
}
