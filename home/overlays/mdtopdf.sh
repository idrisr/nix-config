set -e
set -u

usage() {
  echo "usage: $0 <my-file.md>"
  exit 1
}

if [[ "$#" != 1 ]]; then
  usage
fi

filepath=${1%.*}
filename=${filepath##*/}

pandoc "$filepath.md" --pdf-engine=lualatex -o "$filename.pdf"
