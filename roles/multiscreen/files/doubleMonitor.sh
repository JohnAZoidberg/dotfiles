#!/bin/sh
xrandr --output HDMI-2 --off \
       --output DP-1 --off \
       --output DP-2 --off \
       --output VIRTUAL-1 --off \
       --output HDMI-1 --off \
       \
       --output eDP-1 --primary --rotate normal \
       --mode 1920x1080 --pos 0x1080 \
       \
       --output HDMI-2 --rotate normal \
       --mode 1920x1080 --pos 0x0
