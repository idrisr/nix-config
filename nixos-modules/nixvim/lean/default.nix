{ inputs, ... }: {
  config.programs.nixvim.plugins.lean = {
    leanPackage = inputs.nixpkgs-lean43.legacyPackages.x86_64-linux.lean4;
    enable = true;
  };
}
