set -e
set -u

usage() {
    echo "$0 <old file name> <new file name>"
    exit 1
}

if ! git diff-index --quiet HEAD --; then
    echo "cannot continue with dirty git index"
    exit 1
fi

if [ "$#" != 2 ]; then
    usage
fi

if [[ ! -f "$1" ]]; then
    echo "$1 does not exit"
    exit 1
fi

if [[ -f "$2" ]]; then
    echo "$2 already exists"
    exit 1
fi

sed -i "s/\[\[${1%.md}]]/\[\[${2%.md}]]/g" ./*.md
mv -v "$1" "$2"
