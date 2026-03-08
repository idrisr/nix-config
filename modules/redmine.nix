{ config
, lib
, ...
}:
with lib; let
  cfg = config.my.redmine;
  # Avoid clash with AdGuardHome (also on 3000)
  redminePort = 3001;
in
{
  options = {
    my.redmine.enable = mkOption {
      default = false;
      type = types.bool;
      description = lib.mdDoc "enable Redmine project management web app";
    };
  };

  config = mkIf cfg.enable {
    services.redmine = {
      enable = true;
      address = "0.0.0.0";
      port = redminePort;
    };

    networking.firewall.allowedTCPPorts = [ redminePort ];
  };
}
