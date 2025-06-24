let diskID = "ata-Protectli_240GB_mSATA_511240308060000003";
in {
  disko.devices = {
    disk.router = {
      type = "disk";
      device = "/dev/disk/by-id/${diskID}";

      content = {
        type = "gpt";
        partitions = {
          ESP = {
            size = "500M";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [ "defaults" ];
            };
          };

          root = {
            size = "100%";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/";
            };
          };
        };
      };
    };
  };
}
