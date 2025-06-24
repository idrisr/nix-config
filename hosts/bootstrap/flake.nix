{
  description = "serial-enabled nixos installer iso";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";

  outputs = { self, nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages."${system}";

    in {
      nixosConfigurations.installer = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [ ./default.nix ];
      };

      packages.${system} = rec {
        iso = self.nixosConfigurations.installer.config.system.build.isoImage;
        inherit (self.checks.${system}.default) driverInteractive;
        default = iso;
      };

      checks.${system}.default = pkgs.nixosTest {
        name = "nix config check";
        nodes = { installer = import ./default.nix; };
        testScript = ''
          machine.wait_for_unit("multi-user.target")
          machine.succeed("nix config check")
        '';
      };
    };
}
