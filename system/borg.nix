{ config, pkgs, ... }: {
  config = {
    services.borgbackup.jobs = {
      borgbase = {
        paths = [ "/home/hippoid" ];
        exclude = [ "/home/hippoid/.cache" ];
        repo = "r467e01j@r467e01j.repo.borgbase.com:repo";
        encryption = {
          mode = "repokey-blake2";
          passCommand = "cat /root/borgbackup/passphrase";
        };
        environment = { BORG_RSH = "ssh -i /root/borgbackup/ssh_key"; };
        compression = "auto,lzma";
        startAt = "daily";
        # extraArgs = "--lock-wait 600";
      };
    };
  };
}
