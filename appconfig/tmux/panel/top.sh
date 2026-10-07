#!/bin/sh
xrandr --output eDP-1 --auto --rotate normal \
    --output HDMI-1 --primary --mode 1920x1080 --preferred --scale 1.125x1.125 --rotate normal --above eDP-1
