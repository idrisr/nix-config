#!/bin/sh

set -e
set -u

usage() {
    echo "$0 light|dark"
    return 1
}

if [[ $# -ne 1 ]]
then
    usage
fi


if [[ $1 =~ [dD]ark ]]
then
    theme="dark"
elif [[ $1 =~ [lL]ight ]]
then
    theme="light"
else
    usage
fi

pushd ~/dotfiles/nix/home
home-manager switch -b backup -f ./home.nix -A "${theme}"
popd
