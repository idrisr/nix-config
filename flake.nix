{
  description = "my machines' nixos configuration";

  inputs = {
    nixpkgs.url = "nixpkgs";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware = {
      type = "github";
      owner = "nixos";
      repo = "nixos-hardware";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    knotools = {
      url = "github:idrisr/knotools/6eebffaf8e43aea9e33c73e3bcb70815e3e783d8";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, nixos-hardware, home-manager, knotools, flake-utils
    , disko }:
    let
      system = flake-utils.lib.system.x86_64-linux;
      pkgs = import nixpkgs { inherit system; };
      base = ./system/base.nix;
      homebase = [
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            users.hippoid = import ./home/base.nix;
            useUserPackages = true;
          };
        }
      ];

      homedesk = [
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            users.hippoid = import ./home/desktop.nix knotools;
            useUserPackages = true;
          };
        }
      ];

    in {
      nixosConfigurations = {
        fft = nixpkgs.lib.nixosSystem {
          modules = [
            disko.nixosModules.default
            ./system/hardware-fft.nix
            base
            ./system/disko-fft.nix
            ./system/cockpit
          ] ++ homebase;
        };
        framework = nixpkgs.lib.nixosSystem {
          modules = [
            ./system/hardware-framework.nix
            ./system/desktop.nix
            ./system/cockpit
            base
            nixos-hardware.nixosModules.framework-11th-gen-intel
          ] ++ homebase ++ homedesk;
        };
        air = nixpkgs.lib.nixosSystem {
          modules = [ ./system/cockpit ./system/hardware-air.nix base ]
            ++ homebase;
        };
        red = nixpkgs.lib.nixosSystem {
          modules = [
            ./system/hardware-red.nix
            base
            ./system/printing.nix
            ./system/printer-client.nix
          ] ++ homebase;
        };
        surface = nixpkgs.lib.nixosSystem {
          modules = [
            ./system/hardware-surface.nix
            ./system/borg/borg.nix
            ./system/soulseek
            ./system/desktop.nix
            (import ./system/disko-surface.nix { device = "/dev/nvme0n1"; })
            disko.nixosModules.default
            nixos-hardware.nixosModules.microsoft-surface-pro-intel
            base
          ] ++ homebase ++ homedesk;
        };
      };

      devShells.${system}.default = with pkgs;
        mkShell {
          buildInputs = [
            ghcid
            (ghc.withPackages (p: with p; [ xmonad xmonad-extras dbus ]))
            haskell-language-server
            luajitPackages.lua-lsp
            nodePackages.vim-language-server
          ];
        };
    };
}
