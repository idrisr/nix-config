{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-config = {
      url = "github:idrisr/home-manager-config";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko/545aba02960caa78a31bd9a8709a0ad4b6320a5c";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    opencode = {
      url = "git+file:/home/hippoid/fun/open-code-nixos-module";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = inputs@{ self, nixpkgs, deploy-rs, ... }:
    let
      primarySystem = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${primarySystem};
      lib = nixpkgs.lib;
      homeSystems = [ "x86_64-linux" "aarch64-darwin" ];
      homeConfigurationsBySystem = inputs.home-config.homeConfigurations;
      homeChecks = lib.genAttrs homeSystems (system: {
        home-graphical =
          homeConfigurationsBySystem."graphical-${system}".activationPackage;
        home-headless =
          homeConfigurationsBySystem."headless-${system}".activationPackage;
      });
      deployChecks = builtins.mapAttrs
        (system: deployLib: deployLib.deployChecks self.deploy)
        deploy-rs.lib;
      makeMachine = host: nixpkgs.lib.nixosSystem {
        modules = [
          inputs.home-manager.nixosModules.home-manager
          # inputs.home-config.nixosModules.graphical
          ./hosts/${host}
          ./modules
          {
            config.nixpkgs = {
              hostPlatform = lib.mkDefault primarySystem;
              overlays = inputs.home-config.overlays;
              config.allowUnfree = true;
            };
          }
        ];

        specialArgs = {
          inherit inputs;
          inherit host;
        };
      };
    in
    {
      nixosConfigurations = {
        framework = makeMachine "framework";
        frameland = makeMachine "frameland";
        air = makeMachine "air";
        godel = makeMachine "godel";
        router = makeMachine "router";
        fft = makeMachine "fft";
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
          hostname = "godel.lan";
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

      homeConfigurations = homeConfigurationsBySystem;

      checks = lib.recursiveUpdate deployChecks homeChecks;
    };
}
