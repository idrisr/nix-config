{ config, lib, ... }:
with lib;
let
  idrisrajaHosts = import ../lib/idrisraja-hosts.nix;
in
{
  options = {
    my.localHostOverrides = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = mdDoc ''
          add selected `idrisraja.com` host overrides to `/etc/hosts`
        '';
      };

      allHosts = mkOption {
        default = false;
        type = types.bool;
        description = mdDoc ''
          add all shared `idrisraja.com` host overrides
        '';
      };

      hosts = mkOption {
        default = [ ];
        type = types.listOf types.str;
        description = mdDoc ''
          fully qualified `idrisraja.com` hostnames to add as local overrides
        '';
      };
    };
  };

  config =
    let
      cfg = config.my.localHostOverrides;
      unknownHosts = filter (host: !(builtins.hasAttr host idrisrajaHosts)) cfg.hosts;
      selectedHosts =
        if cfg.allHosts then
          idrisrajaHosts
        else
          filterAttrs (host: _: elem host cfg.hosts) idrisrajaHosts;
      groupedHosts = foldlAttrs (
        acc: host: ip:
        acc
        // {
          ${ip} = (acc.${ip} or [ ]) ++ [ host ];
        }
      ) { } selectedHosts;
    in
    mkIf cfg.enable {
      assertions = [
        {
          assertion = !(cfg.allHosts && cfg.hosts != [ ]);
          message = "my.localHostOverrides.allHosts and my.localHostOverrides.hosts cannot both be set";
        }
        {
          assertion = unknownHosts == [ ];
          message = "my.localHostOverrides.hosts contains unknown hostnames: ${concatStringsSep ", " unknownHosts}";
        }
      ];

      networking.hosts = groupedHosts;
    };
}
