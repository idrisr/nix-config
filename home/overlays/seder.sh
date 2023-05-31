set -e
set -u

usage() {
    echo "$0 <pdf file> <string to remove>"
    exit 1
}

if [ "$#" != 2 ]; then
    usage
fi

if [[ ! -f "$1" ]]; then
    echo "$1 does not exit"
    exit 1
fi

filepath=${1%.*}
filename=${filepath##*/}

cd "$(mktemp -d)"
pdftk "$OLDPWD/$1" output 1.pdf uncompress
sed -e "s/$2//" 1.pdf > 2.pdf
pdftk  2.pdf output 3.pdf compress
mv 3.pdf "$OLDPWD"/"$filename"-new.pdf
