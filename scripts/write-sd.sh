set -euo pipefail

image_file="$1"
device="${2:-/dev/sda}"

if [ -d "$image_file" ]; then
  matches=("$image_file"/*.img "$image_file"/*.img.zst)
  existing=()
  for candidate in "${matches[@]}"; do
    if [ -e "$candidate" ]; then
      existing+=("$candidate")
    fi
  done

  if [ "${#existing[@]}" -ne 1 ]; then
    echo "expected exactly one image in $image_file, found ${#existing[@]}" >&2
    exit 1
  fi

  image_file="${existing[0]}"
fi

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
case "$image_file" in
  *.zst)
    zstd -d -c "$image_file" | dd of="$device" bs=4M conv=fsync status=progress
    ;;
  *)
    dd if="$image_file" of="$device" bs=4M conv=fsync status=progress
    ;;
esac
sync
