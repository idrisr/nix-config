{ config
, lib
, pkgs
, ...
}:
let
  cfg = config.my.nfs-client;
in
{
  options.my.nfs-client.enable = lib.mkEnableOption "NFS client support";

  config = lib.mkIf cfg.enable {
    boot.supportedFilesystems = [ "nfs" ];
    services.rpcbind.enable = true;
    users.groups.hippoid.gid = 980;
    users.users.hippoid.extraGroups = [ "hippoid" ];
    environment.systemPackages = [ pkgs.nfs-utils ];
  };
}
