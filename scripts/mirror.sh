#!/bin/sh

# USB Device
PHONE=$(mtp-detect 2>/dev/null | grep "Model:" | cut -d':' -f2 | xargs)

# container
if [ "$PHONE" = "" ]; then
    echo "No MTP device detected."
    . "$GIT_PATH/linux-setup/scripts/redroid.sh"

else
    echo "Android phone connected: $PHONE"

    # orientation
    adb shell settings put system accelerometer_rotation 0  #disable auto-rotate
    adb shell settings put system user_rotation 3  # 270° clockwise
fi

# display
until
scrcpy --serial 127.0.0.1:5552 --video-codec=h264 --video-encoder=OMX.google.h264.encoder \
    --stay-awake --audio-codec=aac --audio-encoder=OMX.google.aac.encoder #\
    # --max-size 1920 --window-borderless --no-mouse-hover --window-y 0
do

    # server
    sleep 1

    # connect
    adb connect 127.0.0.1:5552
done
