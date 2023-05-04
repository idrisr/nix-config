{ pkgs, lib, ... }: {
  config = {
    environment.systemPackages = with pkgs; [ virtmanager ];
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
