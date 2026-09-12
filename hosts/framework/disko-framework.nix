# disko --mode disko ./disko-framework.nix --argstr device '/dev/nvme0n1'
{
  device ? throw "pass in your device",
  ...
}:
{
  disko.devices = {
    disk.main = {
      type = "disk";
      inherit device;
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            size = "1G";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [
                "fmask=0077"
                "dmask=0077"
              ];
            };
          };
          root = {
            size = "100G";
            content = {
              type = "zfs";
              pool = "rpool";
            };
          };
          home = {
            size = "100%";
            content = {
              type = "zfs";
              pool = "home";
            };
          };
        };
      };
    };

    zpool = {
      rpool = {
        type = "zpool";
        options.ashift = "12";
        rootFsOptions = {
          compression = "zstd";
          atime = "off";
          mountpoint = "none";
        };
        datasets = {
          root = {
            type = "zfs_fs";
            mountpoint = "/";
          };
          nix = {
            type = "zfs_fs";
            mountpoint = "/nix";
          };
        };
      };

      home = {
        type = "zpool";
        options.ashift = "12";
        rootFsOptions = {
          compression = "zstd";
          atime = "off";
          mountpoint = "none";
        };
        datasets.home = {
          type = "zfs_fs";
          mountpoint = "/home";
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
