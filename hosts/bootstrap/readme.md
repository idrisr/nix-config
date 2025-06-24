# Bootable ISO

This flake is for the purposes of bootstrapping a new machine into nixos.  Boot
the new machine via this custom iso, and get its ip address and disk id
information. Then that's enough to get nixos-anywhere and disko installed via a
remote machine.

## Building
```
nix build #iso
```

## Copying to USB
💦74% 🟢 0 ❮ sudo dd if=./result/iso/nixos*.iso of=/dev/sdb bs=4M status=progress
