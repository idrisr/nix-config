#!/bin/sh
pushd ~/dotfiles/nix/system
sudo nixos-rebuild switch -I nixos-config=configuration.nix
popd
