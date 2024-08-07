{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs-lean43.url = "nixpkgs/cbcf0e94ac74";
    nixos-hardware.url = "github:nixos/nixos-hardware";
    flake-utils.url = "github:numtide/flake-utils";
    nix-colors.url = "github:misterio77/nix-colors";
    pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";
    devenv.url = "github:cachix/devenv";
    knotools = {
      url = "github:idrisr/knotools";
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
    nixvim = {
      url = "github:nix-community/nixvim";
      # inputs.nixpkgs.follows = "nixpkgs";
    };
    zettel.url = "path:/home/hippoid/fun/zettel";
    visualpreview.url = "path:/home/hippoid/fun/visualpreview";
    mods.url = "path:/home/hippoid/fun/mods";
    slide2text.url = "github:idrisr/slide2text";
    rofi.url = "path:/home/hippoid/fun/rofi-picker";
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
                ol = [
                  inputs.knotools.overlays.all
                  inputs.knotools.overlays.pipe-rename
                ];
                ol2 = [
                  (import ./nixos-modules/qrcp "6969")
                  (import ./nixos-modules/xournal)
                  (import ./nixos-modules/tikzit)
                ];
              in {
                hostPlatform = pkgs.lib.mkDefault "x86_64-linux";
                overlays = ol ++ ol2 ++ [
                  inputs.zettel.overlays.zettel
                  inputs.visualpreview.overlays.visualpreview
                  inputs.mods.overlays.mods
                  inputs.slide2text.overlays.slide2text
                  inputs.rofi.overlays.all
                ];
                config = {
                  allowUnfreePredicate = pkg:
                    builtins.elem
                    (nixpkgs.legacyPackages.${system}.lib.getName pkg) [
                      "broadcom-sta"
                      "discord"
                      "lastpass-cli"
                      "mathpix-snipping-tool"
                      "makemkv"
                      "obsidian"
                    ];
                };
              };
            }
          ];
          specialArgs = { inherit inputs; };
        };
      hooks = {
        beautysh.enable = true;
        deadnix.enable = true;
        nixfmt.enable = true;
      };
    in {
      nixosConfigurations = { # todo use a fmap
        # air = makeMachine "air";
        # framework = makeMachine "framework";
        fft = makeMachine "fft";
        surface = makeMachine "surface";
      };

      devShells.${system} = let pkgs = nixpkgs.legacyPackages.${system};
      in {
        default = inputs.devenv.lib.mkShell {
          inherit inputs pkgs;
          modules = [{ pre-commit.hooks = hooks; }];
        };
      };

      checks.${system} = {
        pre-commit-check = inputs.pre-commit-hooks.lib.${system}.run {
          inherit hooks;
          src = ./.;
        };
      };
    };
}
