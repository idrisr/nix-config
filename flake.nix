{
  description = "my machines' nixos configuration";

  inputs = {
    nixpkgs = { url = "github:nixos/nixpkgs/nixos-unstable"; };
    nixos-hardware = {
      type = "github";
      owner = "nixos";
      repo = "nixos-hardware";
      rev = "3023004e9903bc2f726da7c4a6724cf55f45bfff";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, nixos-hardware, home-manager, ... }:
    let system = "x86_64-linux";
    in {
      nixosConfigurations = {
        surface2 = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./system/hardware-surface.nix
            ./system/configuration.nix
            nixos-hardware.nixosModules.microsoft-surface-pro-intel
            home-manager.nixosModules.home-manager
            { home-manager.users.hippoid = import home/base.nix; }
          ];
        };

        fft = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./system/hardware-tower.nix
            ./system/configuration.nix
            nixos-hardware.nixosModules.microsoft-surface-pro-intel
            home-manager.nixosModules.home-manager
            { home-manager.users.hippoid = import home/base.nix; }
          ];
        };
      };
    };
}
