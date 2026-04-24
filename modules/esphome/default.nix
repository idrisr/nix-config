{ config
, lib
, pkgs
, ...
}:
with lib;
let
  cfg = config.my.esphome;
in
{
  options = {
    my.esphome = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = lib.mdDoc ''
          enable esphome dashboard
        '';
      };

      address = mkOption {
        default = "127.0.0.1";
        type = types.str;
        description = lib.mdDoc ''
          listen address for esphome
        '';
      };

      port = mkOption {
        default = 6052;
        type = types.port;
        description = lib.mdDoc ''
          listen port for esphome
        '';
      };

      openFirewall = mkOption {
        default = false;
        type = types.bool;
        description = lib.mdDoc ''
          open firewall for esphome port
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    users.groups.esphome = { };
    users.users.esphome = {
      isSystemUser = true;
      group = "esphome";
      home = "/var/lib/esphome";
      createHome = false;
    };

    services.esphome = {
      enable = true;
      address = cfg.address;
      port = cfg.port;
      openFirewall = cfg.openFirewall;
    };

    system.activationScripts.esphomeOwnershipMigration = lib.stringAfter [ "users" ] ''
      state_dir="/var/lib/esphome"
      migration_stamp="$state_dir/.migration-static-user-v1"

      if [ -e "$state_dir" ] && [ ! -e "$migration_stamp" ]; then
        chown -R -H esphome:esphome "$state_dir" 2>/dev/null || true
        touch "$migration_stamp"
        chown esphome:esphome "$migration_stamp" 2>/dev/null || true
      fi
    '';

    systemd.services.esphome.serviceConfig.DynamicUser = mkForce false;
    systemd.services.esphome.environment.PYTHONPATH = mkDefault "${config.services.esphome.package}/${pkgs.python3.sitePackages}";
  };
}
