{ config, pkgs, ... }: {
  config = {
    services.borgbackup.jobs = {
      borgbase = {
        paths = [ "/home/hippoid" ];
        exclude = [ "/home/hippoid/.*" ];
        repo = "r467e01j@r467e01j.repo.borgbase.com:repo";
        encryption = {
          mode = "repokey-blake2";
          passCommand = "cat /root/borgbackup/passphrase";
        };
        environment = { BORG_RSH = "ssh -i /root/borgbackup/ssh_key"; };
        compression = "auto,lzma";
        startAt = "daily";
      };
      fft = {
        paths = [ "/home/hippoid" ];
        exclude = [ "/home/hippoid/.*" ];
        repo = "fft:/var/lib/borgbackup";
        encryption = {
          mode = "repokey-blake2";
          passCommand = "cat /root/borgbackup/passphrase";
        };
        environment = { BORG_RSH = "ssh -i /home/hippoid/.ssh/id_rsa"; };
        compression = "auto,lzma";
        startAt = "daily";
      };
    };
  };
}
