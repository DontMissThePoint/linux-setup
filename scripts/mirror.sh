#!/bin/sh

# start server
scrcpy -w -S --no-mouse-hover --window-borderless --window-y 0 # screen off save power

# orientation
adb shell settings put system accelerometer_rotation 0  #disable auto-rotate
adb shell settings put system user_rotation 3  # 270° clockwise
