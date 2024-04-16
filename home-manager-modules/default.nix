# nixos module entry point to home-manager
{ config, inputs, lib, ... }:
let cfg = config.profile;
in {
  config.home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };
    users = lib.mkMerge [
      { hippoid = import ./profiles/base.nix; }
      (lib.mkIf cfg.dailydrive.enable {
        hippoid = import ./profiles/desktop.nix;
      })
    ];
  };

  options = {
    profile = {
      dailydrive = {
        enable = lib.mkOption {
          default = false;
          type = lib.types.bool;
          description = lib.mdDoc ''
            enable the full tools needed for a user for some banging system
          '';
        };
      };

      minimum = {
        enable = lib.mkOption {
          default = true;
          type = lib.types.bool;
          description = lib.mdDoc ''
            enable the basic tools needed for a user for some usable system
          '';
        };
      };
    };
  };
}
