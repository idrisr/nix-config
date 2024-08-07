{ config, lib, ... }:
let
  cfg = config.borg-backup-client;
  backup = key: repo: {
    paths = [ "/home/hippoid" ];
    exclude = [
      "/home/hippoid/.*"
      "/home/hippoid/videos"
      "/home/hippoid/music"
      "/home/hippoid/downloads"
      "**/.lake"
      "*.img"
      "*.iso"
      "*.qcow2"
      "*.qcow2c"
    ];
    repo = "${repo}";
    encryption = {
      mode = "repokey-blake2";
      passCommand = "cat /root/borgbackup/passphrase02";
    };
    environment = { BORG_RSH = "ssh -i ${key}"; };
    compression = "auto,lzma";
    # startAt = "daily";
    startAt = "09:00";

    prune.keep = {
      within = "1d"; # Keep all archives from the last day
      daily = 7;
      weekly = 4;
      monthly = -1; # Keep at least one archive for each month
    };
  };
in {
  options = {
    borg-backup-client = {
      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description =
          lib.mdDoc "whether to enable the host as borg backup client.";
      };
    };
  };
  config = lib.mkIf cfg.enable {
    # this setup only works for backup from one machine
    # need to think further how to modularize this for n machines
    services.borgbackup.jobs = {
      borgbase = backup "/root/borgbackup/borg02-ed25519"
        "irhb5ap5@irhb5ap5.repo.borgbase.com:repo";
      air = backup "/root/borgbackup/borg02-ed25519" "borg@air:.";
      fft = backup "/root/borgbackup/borg02-ed25519" "borg@fft:.";
    };
  };
}
