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
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, nixos-hardware, home-manager, nixos-generators, ... }:
    let
      system = "x86_64-linux";
      common = [
        ./system/configuration.nix
        home-manager.nixosModules.home-manager
        { home-manager.users.hippoid = import home/base.nix; }

      ];
      pkgs = import nixpkgs { system = system; };
    in {
      packages.x86_64-linux = {
        install = nixos-generators.nixosGenerate {
          system = "x86_64-linux";
          modules = [ ./system/hardware-framework.nix ] ++ common;
          format = "install-iso";
        };
      };

      nixosConfigurations = {
        surface = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./system/hardware-surface.nix
            nixos-hardware.nixosModules.microsoft-surface-pro-intel
          ] ++ common;
        };

        fft = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [ ./system/hardware-fft.nix ] ++ common;
        };

        framework = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [ ./system/hardware-framework.nix ] ++ common;
        };

        red = nixpkgs.lib.nixosSystem {
          system = "i686-linux";
          modules = [ ./system/hardware-red.nix ] ++ common;
        };
      };

      devShells.x86_64-linux.default = with pkgs;
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
