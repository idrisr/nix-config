# nixos module entry point to home-manager
{ config, inputs, lib, ... }:
let cfg = config.profile;
in {
  config.home-manager = lib.mkMerge [
    {
      users.hippoid = import ./profiles/base.nix;
      useUserPackages = true;
      extraSpecialArgs = { inherit inputs; };
    }

    (lib.mkIf cfg.dailydrive.enable {
      users.hippoid = import ./profiles/desktop.nix;
      useUserPackages = true;
      extraSpecialArgs = { inherit inputs; };
    })
  ];

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
