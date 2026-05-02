set -euo pipefail

image_file="$1"
device="${2:-/dev/sda}"

if [ "$(id -u)" -ne 0 ]; then
  echo "run as root: sudo nix run .#write-cust-sd -- /dev/sdX" >&2
  exit 1
fi

if [ ! -b "$device" ]; then
  echo "block device not found: $device" >&2
  exit 1
fi

case "$device" in
  /dev/nvme*n*p[0-9]*|/dev/*[0-9])
    echo "refusing to write to partition device: $device" >&2
    echo "use the whole disk, for example: /dev/sda" >&2
    exit 1
    ;;
esac

sync
zstd -d -c "$image_file" | dd of="$device" bs=4M conv=fsync status=progress
sync
