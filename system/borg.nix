let
  backup = key: repo: {
    paths = [ "/home/hippoid" ];
    exclude = [
      "/home/hippoid/.*"
      "/home/hippoid/videos"
      "*.img"
      "*.iso"
      "*.qcow2"
      "*.qcow2c"
    ];
    repo = "${repo}";
    encryption = {
      mode = "repokey-blake2";
      passCommand = "cat /root/borgbackup/passphrase";
    };
    environment = { BORG_RSH = "ssh -i ${key}"; };
    compression = "auto,lzma";
    # startAt = "daily";
    startAt = "09:00";
  };
in {
  config = {
    services.borgbackup.jobs = {
      borgbase = backup "/root/borgbackup/ssh_key"
        "r467e01j@r467e01j.repo.borgbase.com:repo";
      air = backup "/root/borgbackup/ed25519" "borg@air:.";
      fft = backup "/root/borgbackup/ed25519" "borg@fft:.";
    };
  };
}
