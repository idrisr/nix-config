{ inputs, ... }:
{
  perSystem =
    {
      lib,
      system,
      ...
    }:
    {
      apps.deploy = inputs.deploy-rs.apps.${system}.default;
      packages = lib.optionalAttrs (system == "x86_64-linux" && builtins.hasAttr "rpi4" inputs.self.nixosConfigurations) {
        rpi4-system = inputs.self.nixosConfigurations.rpi4.config.system.build.toplevel;
      };
      formatter = inputs.nixpkgs.legacyPackages.${system}.nixfmt-tree;
    };
}
