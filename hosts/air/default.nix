{ pkgs
, inputs
, ...
}: {
  imports = [ ./hardware-air.nix ];
  config = {
    my.base.enable = true;
    my.borgrepo.enable = true;

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
