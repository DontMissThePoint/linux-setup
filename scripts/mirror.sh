#!/bin/sh

# orientation
adb shell settings put system accelerometer_rotation 0  #disable auto-rotate
adb shell settings put system user_rotation 3  # 270° clockwise

# start server
scrcpy -w --no-mouse-hover --window-borderless --window-y 0 # -S screen off save power
