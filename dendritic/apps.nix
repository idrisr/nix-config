{ inputs, ... }:
{
  perSystem =
    {
      lib,
      system,
      pkgs,
      ...
    }:
    {
      apps.deploy = inputs.deploy-rs.apps.${system}.default;
      packages = lib.optionalAttrs (builtins.hasAttr "rpi4" inputs.self.nixosConfigurations) {
        rpi4-sd-image = inputs.self.nixosConfigurations.rpi4.config.system.build.sdImage;
        rpi4-system = inputs.self.nixosConfigurations.rpi4.config.system.build.toplevel;
      };
      formatter = pkgs.nixfmt-tree;
    };
}
