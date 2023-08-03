{ config, pkgs, ... }: {
  config = {
    services.borgbackup.jobs = {
      borgbase = {
        paths = [ "/home/hippoid" ];
        exclude = [ ];
        repo = "r467e01j@r467e01j.repo.borgbase.com:repo";
        doInit = true;
        encryption = {
          mode = "repokey-blake2";
          passCommand = "cat /root/borgbackup/passphrase";
        };
        environment = {
          BORG_RSH = "ssh -i /root/borgbackup/ssh_key";
          SYSTEMD_LOG_LEVEL = "debug";
        };
        compression = "auto,lzma";
        startAt = "daily";
      };
    };
  };
}
