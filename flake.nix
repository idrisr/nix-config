{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixcord = { url = "github:kaylorben/nixcord"; };
    nixos-hardware.url = "github:nixos/nixos-hardware";
    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    devenv = {
      url = "github:cachix/devenv";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    visualpreview = {
      url = "github:idrisr/visualpreview";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rofi = {
      url = "github:idrisr/rofi-picker/haskell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur = {
      url = "github:idrisr/nur-packages";
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
            ./hosts/${host}
            ./nixos-modules
            {
              config.nixpkgs = {
                hostPlatform = pkgs.lib.mkDefault "x86_64-linux";
                overlays = [
                  inputs.nur.overlays.${system}
                  inputs.visualpreview.overlays.visualpreview
                  inputs.rofi.overlays.all
                  (import ./nixos-modules/qrcp "6969")
                  (import ./nixos-modules/xournal)
                  (import ./nixos-modules/tikzit)
                  (import ./nixos-modules/kdenlive)
                  (import ./nixos-modules/brave)
                ];
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
      };

      checks = builtins.mapAttrs
        (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
    };
}
