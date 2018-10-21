#!/bin/sh
xrandr --output HDMI2 --off \
       --output DP1 --off \
       --output DP2 --off \
       \
       --output eDP1 --primary --rotate normal \
       --mode 1366x768 --pos 304x1080 \
       \
       --output HDMI1 --rotate normal \
       --mode 1920x1080 --pos 0x0
