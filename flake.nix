{
  description = "my machines' nixos configuration";
  inputs = {
    nixpkgs.url = "nixpkgs";
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
      url = "github:idrisr/knotools";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    { self, nixpkgs, nixos-hardware, home-manager, knotools, flake-utils }:
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
            ./system/hardware-fft.nix
            base
            ./system/sdr.nix
            ./system/avahi.nix
          ] ++ homebase;
        };
        framework = nixpkgs.lib.nixosSystem {
          modules = [ ./system/hardware-framework.nix base ];
        };
        air = nixpkgs.lib.nixosSystem {
          modules = [ ./system/hardware-air.nix base ] ++ homebase;
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
            # ./system/printing.nix
            ./system/borg.nix
            ./system/desktop.nix
            ./system/avahi.nix
            ./system/reflex.nix
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
