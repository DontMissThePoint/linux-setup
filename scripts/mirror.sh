#!/bin/sh

# start server
scrcpy -w --no-mouse-hover --window-borderless --window-y 0

# orientation
adb shell settings put system accelerometer_rotation 0  #disable auto-rotate
adb shell settings put system user_rotation 3  # 270° clockwise
