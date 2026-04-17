#!/bin/sh

# Find MTP mount points in gvfs
MTP_DIR="/run/user/$(id -u)/gvfs"
PHONE=$(ls "$MTP_DIR" 2>/dev/null | grep "mtp:")

if [ "$PHONE" != "" ]; then
    echo "Android phone connected: $PHONE"
    # To list files: ls "$MTP_DIR/$PHONE"
else
    echo "No MTP Android phone detected."
fi

# start server
adb start-server

# orientation
adb shell settings put system accelerometer_rotation 0  #disable auto-rotate
adb shell settings put system user_rotation 3  # 270° clockwise

# connect
adb connect localhost:5556 || echo "OK."
scrcpy -w --video-codec=h264 --video-encoder=OMX.google.h264.encoder \
    --audio-codec=aac --audio-encoder=OMX.google.aac.encoder \
    --max-size 1920 --window-borderless
# scrcpy -w --max-size 1600 --no-mouse-hover --window-borderless --window-y 0 # -S screen off save power
