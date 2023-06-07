set -e
set -u

usage() {
  echo "usage: $0 <transcribe-me.pdf> <start page> <end page>"
  exit 1
}

check_integer() {
    if ! [[ "$1" =~ ^[0-9]+$ ]]; then
        echo "$1 is not an integer"
        usage
    fi
}

check_is_pdf() {
    if ! [[ $(file --dereference --brief --mime-type -- "$1") =~ ^.*pdf$ ]]; then
        echo "$1 is not a pdf file"
        usage
    fi
}

check_valid_ints() {
    if ! [ "$1" -le "$2" ]; then
        echo "invalid page range: $1 $2"
        usage
    fi
}

check_is_file() {
    if [[ ! -f "$1" ]]; then
        echo "$1 is not a file"
        exit 1
    fi
}

check_argc () {
    if [[ "$#" != 3 ]]; then
        echo "invalid arg count"
        usage
    fi
}

check_argc "$@"
check_is_file "$1"
check_integer "$2"
check_integer "$3"
check_valid_ints "$2" "$3"
check_is_pdf "$1"

input=$(realpath "$1")
filepath=${1%.*}
dest=${filepath##*/}

cd "$(mktemp -d)"
pdftoppm -forcenum -progress -cropbox -jpeg -f "$2" -l "$3" "$input" "$dest"

for f in *jpg; do
    filepath=${f%.*}
    filename=${filepath##*/}
    tesseract "$f" "$filename"
    cat "$filename.txt" >> "$OLDPWD/${dest}.txt"
done
