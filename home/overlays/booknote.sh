set -e
set -u

usage() {
    echo "$0 <pdf file> <directory destination>"
    exit 1
}

if [ "$#" != 2 ]; then
    usage
fi

if [[ ! -f "$1" ]]; then
    echo "$1 does not exit"
    exit 1
fi

if [[ ! -d "$2" ]]; then
    echo "$2 does not exit"
    exit 1
fi

filepath=${1%.*}
filename=${filepath##*/}
pdftc "$1" >> "$2/${filename//-/ }.md"
