{
  description = "serial-enabled nixos installer iso";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages."${system}";
      qemuOptions = [
        "-nographic"
        "-serial"
        "mon:stdio"
        "-device"
        "virtio-net-pci,netdev=net0,mac=00:e0:67:30:ae:a6"
        "-netdev"
        "user,id=net4"
        "-device"
        "virtio-net-pci,netdev=net1,mac=00:e0:67:30:ae:a7"
        "-netdev"
        "user,id=net5"
      ];

      qemuOptStr = builtins.concatStringsSep " " qemuOptions;

    in {
      nixosConfigurations.installer = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [ ./default.nix inputs.disko.nixosModules.default ];
      };

      packages.${system} = rec {
        iso = self.nixosConfigurations.installer.config.system.build.toplevel;
        vm = self.nixosConfigurations.installer.config.system.build.vmWithDisko;
        inherit (self.checks.${system}.default) driverInteractive;
        default = iso;
      };

      devShells.${system}.default = pkgs.mkShell {
        shellHook = ''
          export QEMU_OPTS='${qemuOptStr}';
        '';
      };

      checks.${system}.default = pkgs.testers.runNixOSTest {
        name = "nix config check";

        nodes.installer = {
          imports = [ ./default.nix inputs.disko.nixosModules.default ];
          # virtualisation.qemu.options = qemuOptions;
        };

        testScript = builtins.readFile ./script.py;
      };
    };
}
