#!/bin/sh
# shellcheck disable=SC3010 # [[ undefined
# shellcheck disable=SC3044 # popd and pushd undefined in posix

set -e
set -u

pushd ~/dotfiles/system
sudo nixos-rebuild switch -I nixos-config=configuration.nix
popd
