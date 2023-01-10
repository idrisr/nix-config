#!/usr/bin/env bash

set -e
set -u

usage() {
    echo "$0 light|dark"
}

AIRLINE=~/dotfiles/nix/home/neovim/plugin/airline.vim
ALACRITTY=~/dotfiles/nix/home/alacritty/default.nix
GIT=~/dotfiles/nix/home/git/default.nix
LAZYGIT=~/dotfiles/nix/home/lazygit/default.nix
VIM=~/dotfiles/nix/home/neovim/vimrc
VIFM=~/dotfiles/nix/home/vifm/vifmrc
QUTE=~/dotfiles/nix/home/qutebrowser/default.nix

if [[ $1 =~ [dD]ark ]]
then
    echo "switching to dark theme"
    sed -i '/airline_solarized_bg/ s/light/dark/' "$AIRLINE"
    sed -i '/colors = import/ s/light/dark/' "$ALACRITTY"
    sed -i '/set background/       s/light/dark/' "$VIM"
    sed -i '/light = true/         s/true/false/' "$GIT"
    sed -i '/lightTheme/           s/true/false/' "$LAZYGIT"
    sed -i '/source $VIFM\/solarized/   s/light/dark/' "$VIFM"
    sed -i '/colors.webpage.preferred_color_scheme/   s/light/dark/' "$QUTE"
elif [[ $1 =~ [lL]ight ]]
then
    echo "switching to light theme"
    sed -i '/colors = import/ s/dark/light/' "$ALACRITTY"
    sed -i '/set background/       s/dark/light/' "$VIM"
    sed -i '/airline_solarized_bg/ s/dark/light/' "$AIRLINE"
    sed -i '/light = false/        s/false/true/' "$GIT"
    sed -i '/lightTheme/           s/false/true/' "$LAZYGIT"
    sed -i '/source $VIFM\/solarized/   s/dark/light/' "$VIFM"
    sed -i '/colors.webpage.preferred_color_scheme/   s/dark/light/' "$QUTE"
else
    usage
fi
