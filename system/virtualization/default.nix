{ pkgs, lib, ... }: {
  config = {
    environment.systemPackages = with pkgs; [
      virt-viewer
      libosinfo
      virtmanager
    ];

    boot = { kernelModules = [ "nbd" ]; };

    virtualisation.libvirtd = {
      enable = true;
      qemu = {
        ovmf.enable = true;
        runAsRoot = false;
      };
      onBoot = "ignore";
      onShutdown = "shutdown";
    };
  };
}
