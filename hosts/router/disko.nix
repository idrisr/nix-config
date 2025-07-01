let diskID = "ata-Protectli_240GB_mSATA_511240308060000003";
in {
  disko.devices = {
    disk = {
      router = {
        type = "disk";
        device = "/dev/disk/by-id/${diskID}";

        content = {
          type = "gpt";
          partitions = {
            bios = {
              size = "1M";
              type = "EF02"; # BIOS boot partition — no content
            };

            boot = {
              size = "1G";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/boot";
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
  };
}
