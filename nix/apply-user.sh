#!/bin/sh
pushd ~/dotfiles/nix/home
home-manager switch -b backup -f ./home.nix
popd
