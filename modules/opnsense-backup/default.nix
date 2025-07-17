{ config, pkgs, lib, ... }:

let
  cfg = config.my.opnsenseBackup;
  backup-opnsense = pkgs.writeShellApplication {
    name = "backup-opnsense";
    runtimeInputs = [ pkgs.openssh pkgs.coreutils ];
    text = ''
      mkdir -p "/home/hippoid/backups/opnsense"
      scp root@192.168.1.1:/conf/config.xml "/home/hippoid/backups/opnsense/config-$(date +%F).xml"
    '';
  };
in
{
  options = {
    my.opnsenseBackup = {
      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = lib.mdDoc ''
          turn on opnsense config backups from a known source
        '';
      };
    };
  };
  config = lib.mkIf cfg.enable
    {
      systemd.services.backup-opnsense = {
        description = "Backup OPNsense config.xml via SCP";
        serviceConfig = {
          ExecStart = "${lib.getExe backup-opnsense}";
          User = "hippoid";
        };
      };
    };
}
