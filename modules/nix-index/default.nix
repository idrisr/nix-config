{ config, inputs, lib, ... }:
let
  cfg = config.my.nix-index;
in
{
  imports = [ inputs.nix-index-database.nixosModules.default ];

  options.my.nix-index = {
    enable = lib.mkEnableOption "nix-index integration" // {
      default = true;
    };

    database.enable = lib.mkEnableOption "nix-index-database integration" // {
      default = false;
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      programs.nix-index.enable = true;
    })
    (lib.mkIf cfg.database.enable {
      programs.nix-index-database.comma.enable = true;
    })
  ];
}
