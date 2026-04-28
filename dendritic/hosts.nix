{ inputs, ... }:
let
  lib = inputs.nixpkgs.lib;
  hosts = {
    framework = {
      system = "x86_64-linux";
      deploy.hostname = "framework";
    };
    air = {
      system = "x86_64-linux";
      deploy.hostname = "air";
    };
    godel = {
      system = "x86_64-linux";
      deploy.hostname = "godel.lan";
    };
    router = {
      system = "x86_64-linux";
      deploy.hostname = "192.168.50.23";
    };
    fft.system = "x86_64-linux";
    rpi4 = {
      system = "aarch64-linux";
      deploy.hostname = "rpi4";
    };
  };

  mkHost = host:
    let
      hostConfig = hosts.${host};
    in
    inputs.nixpkgs.lib.nixosSystem {
      system = hostConfig.system;
      modules = [
        inputs.self.modules.nixos.all
        (builtins.getAttr host inputs.self.modules.nixos)
      ];
      specialArgs = {
        inherit inputs host;
      };
    };

  mkDeployNode = host:
    let
      hostConfig = hosts.${host};
    in
    {
      hostname = hostConfig.deploy.hostname;
      profiles.system = {
        sshUser = "hippoid";
        user = "root";
        path =
          inputs.deploy-rs.lib.${hostConfig.system}.activate.nixos
          inputs.self.nixosConfigurations.${host};
      };
    };
in
{
  flake.nixosConfigurations = lib.mapAttrs (host: _: mkHost host) hosts;

  flake.deploy.nodes = lib.mapAttrs
    (host: _: mkDeployNode host)
    (lib.filterAttrs (_: hostConfig: hostConfig ? deploy) hosts);
}
