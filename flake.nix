{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    dcgm.url = "git+file:/home/hippoid/fun/prometheus";
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";
    nixos-hardware.url = "github:nixos/nixos-hardware";
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-config = {
      url = "github:idrisr/home-manager-config";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko/545aba02960caa78a31bd9a8709a0ad4b6320a5c";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, nix-darwin, home-manager, ... }:
    let
      host = "mini";
      user = "hippoid";
      system = "aarch64-darwin";
      base = inputs.flake-parts.lib.mkFlake { inherit inputs; }
        (inputs.import-tree ./dendritic);
    in
    base // {
      darwinConfigurations.${host} = nix-darwin.lib.darwinSystem {
        inherit system;
        specialArgs = {
          inherit inputs host user;
        };
        modules = [
          ({ pkgs, ... }: {
            nix.settings.experimental-features = [ "nix-command" "flakes" ];
            nixpkgs.hostPlatform = system;
            networking.hostName = host;
            users.users.${user}.home = "/Users/${user}";

            environment.systemPackages = with pkgs; [
              git
              curl
              prometheus-node-exporter
            ];

            system.stateVersion = 4;
          })
          ./hosts/macbook/default.nix

          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${user} = import ./hosts/macbook/home.nix;
          }
        ];
      };
    };
}
