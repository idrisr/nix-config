{ inputs, ... }:
let
  bootstrapImage = inputs.nixpkgs.lib.nixosSystem {
    system = "aarch64-linux";
    modules = [
      inputs.self.modules.nixos.bootstrap-rpi4-image
    ];
    specialArgs = {
      inherit inputs;
      host = "cust-bootstrap";
    };
  };
in
{
  perSystem =
    {
      lib,
      pkgs,
      self',
      system,
      ...
    }:
    {
      apps =
        {
          deploy = inputs.deploy-rs.apps.${system}.default;
        }
        // lib.optionalAttrs (system == "x86_64-linux") {
          write-cust-sd = {
            type = "app";
            program = "${pkgs.lib.getExe self'.packages.write-cust-sd}";
          };
          default = self'.apps.write-cust-sd;
        };
      packages =
        lib.optionalAttrs (system == "x86_64-linux" && builtins.hasAttr "rpi4" inputs.self.nixosConfigurations) {
          rpi4-system = inputs.self.nixosConfigurations.rpi4.config.system.build.toplevel;
        }
        // lib.optionalAttrs (system == "x86_64-linux") {
          cust-bootstrap-sd-image = bootstrapImage.config.system.build.sdImage;
          write-cust-sd = pkgs.callPackage ../packages/write-sd.nix {
            imageFile = "${bootstrapImage.config.system.build.sdImage}/sd-image/${bootstrapImage.config.system.build.sdImage.meta.name}";
          };
        };
      formatter = inputs.nixpkgs.legacyPackages.${system}.nixfmt-tree;
    };
}
