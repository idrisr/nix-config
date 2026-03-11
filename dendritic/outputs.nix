{ inputs, ... }:
let
  lib = inputs.nixpkgs.lib;
  homeSystems = [ "x86_64-linux" "aarch64-darwin" ];
  homeConfigurationsBySystem = inputs."home-config".homeConfigurations;
  homeChecks = lib.genAttrs homeSystems (system:
    let
      graphicalKey = "graphical-${system}";
      headlessKey = "headless-${system}";
    in
    (lib.optionalAttrs (builtins.hasAttr graphicalKey homeConfigurationsBySystem) {
      home-graphical =
        homeConfigurationsBySystem.${graphicalKey}.activationPackage;
    })
    // (lib.optionalAttrs (builtins.hasAttr headlessKey homeConfigurationsBySystem) {
      home-headless =
        homeConfigurationsBySystem.${headlessKey}.activationPackage;
    }));
  deployChecks =
    builtins.mapAttrs
      (system: deployLib: deployLib.deployChecks inputs.self.deploy)
      inputs.deploy-rs.lib;
in
{
  flake = {
    homeConfigurations = homeConfigurationsBySystem;
    checks = lib.recursiveUpdate deployChecks homeChecks;
  };
}
