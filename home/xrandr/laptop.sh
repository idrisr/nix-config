#!/bin/sh

xrandr                                                    \
--output eDP-1 --mode 2880x1920 --pos 0x0 --rotate normal \
--output DP-1 --off                                       \
--output DP-2 --off                                       \
--output DP-3 --off                                       \
--output HDMI-1 --off
