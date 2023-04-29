#!/bin/sh

pushd ~/dotfiles/system
sudo nixos-rebuild switch -I nixos-config=configuration.nix
popd
