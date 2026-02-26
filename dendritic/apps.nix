{ inputs, ... }:
{
  perSystem = { system, ... }: {
    apps.deploy = inputs.deploy-rs.apps.${system}.default;
  };
}
