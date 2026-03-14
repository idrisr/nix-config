{ pkgs
, inputs
, ...
}: {
  options = { };

  imports = [
    ./hardware-fft.nix
    # inputs.dcgm.nixosModules.dcgm-exporter
  ];

  config = {
    nvidia-gpu.enable = true;
    ollama.enable = true;
    my.base.enable = true;
    my."initrd-remote-unlock".enable = true;
    my.anki.enable = true;
    my.jellyfin.enable = true;
    my.immich.enable = true;
    my.borgrepo.enable = true;
    my.servernode.enable = true;
    networking.firewall.allowedTCPPorts = [ 80 443 ];

    services.nix-serve = {
      enable = true;
      secretKeyFile = "/var/lib/nix-serve/cache-priv-key.pem";
      openFirewall = true;
    };

    environment.systemPackages = with pkgs; [
      atuin
      binutils
      lego
      certbot
    ];
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      extraSpecialArgs = {
        inherit inputs;
        graphical = false;
        pkgs = pkgs;
      };
      users.hippoid = import (inputs."home-config" + "/home.nix");
    };
  };
}
