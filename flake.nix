{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixcord = { url = "github:kaylorben/nixcord"; };
    nixos-hardware.url = "github:nixos/nixos-hardware";
    sops-nix.url = "github:mic92/sops-nix";
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

  outputs = inputs@{ nixpkgs, stylix, sops-nix, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      makeMachine = host:
        nixpkgs.lib.nixosSystem {
          modules = [
            stylix.nixosModules.stylix
            ./hosts/${host}
            ./nixos-modules
            sops-nix.nixosModules.sops
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
        fft = makeMachine "fft";
        surface = makeMachine "surface";
        air = makeMachine "air";
        proxmox = makeMachine "proxmoxvm";
        hypr = nixpkgs.lib.nixosSystem {
          pkgs = nixpkgs.legacyPackages.${system};
          modules = [
            (import ./hosts/framework/hardware-framework.nix)
            (import ./hosts/hypr/module.nix)
          ];
          specialArgs = { inherit inputs; };
        };
      };
    };
}
