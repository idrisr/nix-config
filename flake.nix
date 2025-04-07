{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    hyprland.url = "github:hyprwm/Hyprland";
    nixcord = { url = "github:kaylorben/nixcord"; };
    nixos-hardware.url = "github:nixos/nixos-hardware";
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";
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
      url = "github:idrisr/rofi-picker";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur = {
      # url = "github:idrisr/nur-packages";
      url = "path:/home/hippoid/fun/nur-packages";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ nixpkgs, stylix, ... }:
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
