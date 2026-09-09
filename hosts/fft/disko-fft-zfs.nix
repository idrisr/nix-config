{
  disko.devices = {
    disk = {
      tank1 = {
        type = "disk";
        device = "/dev/disk/by-id/ata-ST4000VN008-2DR166_ZDH7R1Z4";
        content = {
          type = "gpt";
          partitions.zfs = {
            size = "100%";
            content = {
              type = "zfs";
              pool = "tank";
            };
          };
        };
      };

      tank2 = {
        type = "disk";
        device = "/dev/disk/by-id/ata-ST4000VN008-2DR166_ZDH7RKBX";
        content = {
          type = "gpt";
          partitions.zfs = {
            size = "100%";
            content = {
              type = "zfs";
              pool = "tank";
            };
          };
        };
      };

      backup = {
        type = "disk";
        device = "/dev/disk/by-id/ata-ST4000VN008-2DR166_ZGY70CTF";
        content = {
          type = "gpt";
          partitions.zfs = {
            size = "100%";
            content = {
              type = "zfs";
              pool = "backup";
            };
          };
        };
      };
    };

    zpool = {
      tank = {
        type = "zpool";
        mode = "mirror";

        options.ashift = "12";

        rootFsOptions = {
          compression = "zstd";
          atime = "off";
        };

        datasets.data = {
          type = "zfs_fs";
          mountpoint = "/data";
          options = {
            encryption = "aes-256-gcm";
            keyformat = "passphrase";
            keylocation = "prompt";
          };
        };
      };

      backup = {
        type = "zpool";
        options.ashift = "12";

        rootFsOptions = {
          compression = "zstd";
          atime = "off";
        };

        datasets.data = {
          type = "zfs_fs";
          mountpoint = "/backup";
          options = {
            encryption = "aes-256-gcm";
            keyformat = "passphrase";
            keylocation = "prompt";
          };
        };
      };
    };
  };
}
