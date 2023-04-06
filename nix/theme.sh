#!/usr/bin/env bash

set -e
set -u

usage() {
    echo "$0 light|dark"
}

VIFM=~/dotfiles/nix/home/vifm/vifmrc

if [[ $1 =~ [dD]ark ]]
then
    echo "switching to dark theme"
    sed -i '/source $VIFM\/solarized/ s/light/dark/' "$VIFM"
elif [[ $1 =~ [lL]ight ]]
then
    echo "switching to light theme"
    sed -i '/source $VIFM\/solarized/ s/dark/light/' "$VIFM"
else
    usage
fi
