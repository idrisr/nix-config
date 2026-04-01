{ inputs, ... }:
{
  perSystem =
    {
      system,
      pkgs,
      ...
    }:
    {
      apps.deploy = inputs.deploy-rs.apps.${system}.default;
      formatter = pkgs.nixfmt-tree;
    };
}
