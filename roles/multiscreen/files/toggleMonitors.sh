#!/bin/sh
DIR="$HOME/dotfiles/roles/multiscreen/files"
xrandr --listactivemonitors | grep HDMI > /dev/null && "$DIR/singleMonitor.sh" || "$DIR/doubleMonitor.sh"
