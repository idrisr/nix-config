{
  description = "my machines' nixos configuration";

  inputs = {
    nixpkgs.url = "nixpkgs";
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
    knotools = {
      url = "github:idrisr/knotools";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    tasks = {
      inputs.nixpkgs.follows = "nixpkgs";
      # url = "/home/hippoid/fun/mods";
      url = "git+ssh://git@github.com/idrisr/mods.git";
    };
  };

  outputs = { self, nixpkgs, nixos-hardware, home-manager, nixos-generators
    , knotools, tasks }:
    let
      system = "x86_64-linux";
      common = [
        ./system/configuration.nix
        home-manager.nixosModules.home-manager
        {
          config = {
            nixpkgs.overlays = with knotools.overlays; [
              awscost
              booknote
              dimensions
              epubthumb
              mdtopdf
              newcover
              pdftc
              roamamer
              seder
              transcribe
              (import ./home/xrandr/overlay.nix)
              tasks.overlays.tasks
              # hoon-language-server.overlays.hoon-language-server
            ];
          };
        }
        {
          home-manager = {
            users.hippoid = import home/base.nix;
            useUserPackages = true;
          };
        }
      ];
      pkgs = import nixpkgs { inherit system; };

    in {
      packages.${system} = {
        install = nixos-generators.nixosGenerate {
          inherit system;
          modules = [ ./system/hardware-framework.nix ] ++ common;
          format = "install-iso";
        };
      };
      nixosConfigurations = {
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
        surface = nixpkgs.lib.nixosSystem {
          inherit system;
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
