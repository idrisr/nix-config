{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware";
    flake-utils.url = "github:numtide/flake-utils";
    nix-colors.url = "github:misterio77/nix-colors";
    pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";
    knotools.url =
      "github:idrisr/knotools/6eebffaf8e43aea9e33c73e3bcb70815e3e783d8";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # zettel.url = "github:idrisr/zettel";
    zettel.url = "path:/home/hippoid/fun/zettel";
    visualpreview.url = "path:/home/hippoid/fun/visualpreview";
  };

  outputs = inputs@{ nixpkgs, flake-utils, ... }:
    let
      system = flake-utils.lib.system.x86_64-linux;
      pkgs = nixpkgs.legacyPackages.${system};
      makeMachine = host:
        nixpkgs.lib.nixosSystem {
          modules = [
            ./hosts/${host}
            ./nixos-modules
            {
              config.nixpkgs = let
                ol = with inputs.knotools.overlays; [
                  awscost
                  booknote
                  epubthumb
                  mdtopdf
                  newcover
                  pdftc
                  roamamer
                  seder
                  transcribe
                ];
                ol2 = [
                  (import ./nixos-modules/qrcp "6969")
                  (import ./nixos-modules/xournal)
                  (import ./nixos-modules/tikzit)
                ];
              in {
                hostPlatform = pkgs.lib.mkDefault "x86_64-linux";
                overlays = ol ++ ol2 ++ [ inputs.zettel.overlays.zettel ];
                config = {
                  allowUnfreePredicate = pkg:
                    builtins.elem
                    (nixpkgs.legacyPackages.${system}.lib.getName pkg) [
                      "broadcom-sta"
                      "discord"
                      "gitkraken"
                      "lastpass-cli"
                      "mathpix-snipping-tool-03.00.0072"
                      "makemkv"
                    ];
                };
              };
            }
          ];
          specialArgs = { inherit inputs; };
        };
    in {
      nixosConfigurations = { # todo use a fmap
        # air = makeMachine "air";
        # framework = makeMachine "framework";
        fft = makeMachine "fft";
        surface = makeMachine "surface";
        hostPlatform = pkgs.lib.mkDefault "x86_64-linux";
      };

      devShells.${system} = {
        default = with pkgs;
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

      checks.${system} = {
        pre-commit-check = inputs.pre-commit-hooks.lib.${system}.run {
          src = ./.;
          hooks = {
            nixfmt.enable = true;
            deadnix.enable = true;
          };
        };
      };
    };
}
