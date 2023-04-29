set -e
set -u

usage() {
  echo "usage: $0 <transcribe-me.pdf>"
  exit 1
}

if [[ "$#" != 1 ]]; then
  usage
fi

filepath=${1%.*}
filename=${filepath##*/}
declare -i length
length=$(pdfinfo "$1" | sed -n '/Pages:/ s/[^0-9]*\([0-9]\+\)/\1/p')

pushd "$(mktemp -d)"

touch "$OLDPWD/${filename}.txt"
for ((i=1; i<="$length"; i++))
do
    # dont need to call this each time in the loop
    # instead call pdftoppm just once
    pdftoppm -jpeg -f "$i" -singlefile "$OLDPWD/$1" "$i"
    tesseract "$i".jpg "$i"
    cat "$i.txt" >> "$OLDPWD/${filename}.txt"
done
popd

# TODO: add trap to remove tmp files
trash "$OLDPWD"
