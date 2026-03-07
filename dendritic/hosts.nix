{inputs, ...}: let
  primarySystem = "x86_64-linux";
  mkHost = host:
    inputs.nixpkgs.lib.nixosSystem {
      system = primarySystem;
      modules = [
        inputs.self.modules.nixos.all
        (builtins.getAttr host inputs.self.modules.nixos)
      ];
      specialArgs = {
        inherit inputs host;
      };
    };
in {
  flake.nixosConfigurations = {
    framework = mkHost "framework";
    air = mkHost "air";
    godel = mkHost "godel";
    router = mkHost "router";
    fft = mkHost "fft";
  };

  flake.deploy.nodes = {
    framework = {
      hostname = "framework";
      profiles.system = {
        sshUser = "hippoid";
        user = "root";
        path =
          inputs.deploy-rs.lib.x86_64-linux.activate.nixos
          inputs.self.nixosConfigurations.framework;
      };
    };

    air = {
      hostname = "air";
      profiles.system = {
        sshUser = "hippoid";
        user = "root";
        path =
          inputs.deploy-rs.lib.x86_64-linux.activate.nixos
          inputs.self.nixosConfigurations.air;
      };
    };

    godel = {
      hostname = "godel.lan";
      profiles.system = {
        sshUser = "hippoid";
        user = "root";
        path =
          inputs.deploy-rs.lib.x86_64-linux.activate.nixos
          inputs.self.nixosConfigurations.godel;
      };
    };

    router = {
      hostname = "192.168.50.23";
      profiles.system = {
        sshUser = "hippoid";
        user = "root";
        path =
          inputs.deploy-rs.lib.x86_64-linux.activate.nixos
          inputs.self.nixosConfigurations.router;
      };
    };
  };
}
