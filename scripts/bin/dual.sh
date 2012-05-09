#!/bin/bash
OTHER=HDMI1
if [ -n "$1" ]; then
    OTHER=$1
fi
xrandr --output $OTHER --auto
xrandr --output LVDS1 --left-of $OTHER --auto
