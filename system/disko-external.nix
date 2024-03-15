# disko --mode disko ./disko-external.nix --argstr "device" '/dev/<disk>' --argstr "name" '<name>'
{ device ? throw "pass in your device", name ? throw "pass in name", ... }: {
  disko.devices = {
    disk = {
      vdb = {
        type = "disk";
        inherit device;
        content = {
          type = "gpt";
          partitions = {
            luks = {
              size = "100%";
              content = {
                type = "luks";
                name = "${name}-external";
                passwordFile = "/tmp/secret.key";
                content = {
                  type = "filesystem";
                  format = "ext4";
                  mountpoint = "/${name}";
                  mountOptions = [ "defaults" ];
                };
              };
            };
          };
        };
      };
    };
  };
}
