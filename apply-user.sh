#!/bin/sh
# shellcheck disable=SC3010 # [[ undefined
# shellcheck disable=SC3044 # popd and pushd undefined in posix


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

pushd ~/dotfiles/home
home-manager switch -b backup --file ./home.nix -A "${theme}"
popd
