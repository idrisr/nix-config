{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-config = {
      url = "path:/home/hippoid/home-manager-config";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rofi = {
      url = "github:idrisr/rofi-picker/haskell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, stylix, deploy-rs, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      makeMachine = host:
        nixpkgs.lib.nixosSystem {
          modules = [
            stylix.nixosModules.stylix
            inputs.home-manager.nixosModules.home-manager
            ./hosts/${host}
            ./nixos-modules
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                backupFileExtension = "bak";
                users.hippoid = {
                  home = {
                    homeDirectory = "/home/hippoid";
                    stateVersion = "25.05";
                    username = "hippoid";
                  };
                  imports = [ inputs.home-config.homeManagerModules.base ];
                };
              };
            }
            {
              config.nixpkgs = {
                hostPlatform = pkgs.lib.mkDefault "x86_64-linux";
                overlays = [ inputs.rofi.overlays.all ];
                config = { allowUnfree = true; };
              };
            }
          ];
          specialArgs = {
            inherit inputs;
            inherit host;
          };
        };
    in {
      nixosConfigurations = {
        framework = makeMachine "framework";
        frameland = makeMachine "frameland";
        air = makeMachine "air";
        godel = makeMachine "godel";
        router = makeMachine "router";
      };

      deploy.nodes = {
        framework = {
          hostname = "framework";
          profiles.system = {
            sshUser = "hippoid";
            user = "root";
            path = deploy-rs.lib.x86_64-linux.activate.nixos
              self.nixosConfigurations.framework;
          };
        };

        air = {
          hostname = "air";
          profiles.system = {
            sshUser = "hippoid";
            user = "root";
            path = deploy-rs.lib.x86_64-linux.activate.nixos
              self.nixosConfigurations.air;
          };
        };

        godel = {
          hostname = "192.168.1.4";
          profiles.system = {
            sshUser = "hippoid";
            user = "root";
            path = deploy-rs.lib.x86_64-linux.activate.nixos
              self.nixosConfigurations.godel;
          };
        };

        router = {
          hostname = "192.168.50.23";
          profiles.system = {
            sshUser = "hippoid";
            user = "root";
            path = deploy-rs.lib.x86_64-linux.activate.nixos
              self.nixosConfigurations.router;
          };
        };
      };

      checks = builtins.mapAttrs
        (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
    };
}
