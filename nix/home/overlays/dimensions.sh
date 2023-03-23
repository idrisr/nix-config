set -e
set -u

usage() {
  echo "usage: $0 <my-file.md>"
  exit 1
}

if [[ "$#" != 1 ]]; then
  usage
fi

pdftk "$1" dump_data_utf8 | rg --text dimension | sort -u
