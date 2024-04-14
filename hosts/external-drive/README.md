# Disko external drive config


```
disko \
    --mode disko ./disko-external.nix \
    --argstr "device" '/dev/<disk>'   \
    --argstr "name" '<name>'
```

Get the block device name from doing something like `lsblk`, and then choose a
name for the disk. Then run the above command passing in the device name and
chosen name. The drive will be formatted like luks, and will use as its secret
the contents of a file '/tmp/secret.key'.
