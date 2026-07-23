{ lib
, pkgs
, inputs
, ...
}: {
  imports = [ ./hardware-air.nix ];
  config = {
    my.base.enable = true;
    my.borgrepo.enable = true;
    my."initrd-remote-unlock".enable = true;
    programs.hyprland.enable = lib.mkForce false;
    services.greetd.enable = lib.mkForce false;
    systemd.defaultUnit = "multi-user.target";

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
