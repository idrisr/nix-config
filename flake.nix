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
      common = [
        ./system/configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            users.hippoid = import home/base.nix knotools;
            useUserPackages = true;
          };
        }
      ];

    in {
      nixosConfigurations = {
        fft = nixpkgs.lib.nixosSystem {
          modules = [ ./system/hardware-fft.nix ] ++ common;
        };
        framework = nixpkgs.lib.nixosSystem {
          modules = [ ./system/hardware-framework.nix ] ++ common;
        };
        air = nixpkgs.lib.nixosSystem {
          modules = [ ./system/hardware-air.nix ] ++ common;
        };
        red = nixpkgs.lib.nixosSystem {
          modules = [ ./system/hardware-red.nix ] ++ common;
        };
        surface = nixpkgs.lib.nixosSystem {
          modules = [
            ./system/hardware-surface.nix
            ./system/printing.nix
            ./system/borg.nix
            nixos-hardware.nixosModules.microsoft-surface-pro-intel
          ] ++ common;
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
