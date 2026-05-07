#!/bin/sh

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Detect device
PHONE=$(mtp-detect 2>/dev/null | grep "Model:" | cut -d':' -f2 | xargs)

# If it does not exist,
# creates and starts the container.
DROID="redroid11"

# server
adb start-server

if [ "$PHONE" = "" ]; then
    echo "No MTP device detected."

    # Check if the container exists
    if docker inspect "$DROID" > /dev/null 2>&1; then
        echo "The container $DROID exists."

        # Check if the container is running
        if "$(docker inspect -f '{{.State.Status}}' "$DROID" | grep -q "running")"; then
            echo "The container $DROID is running."
        else
            echo "The container $DROID is not running."

            # Wait for the container
            echo "Waiting for ReDroid to resume..."

            # Start the container if it is not running
            docker start "$DROID"
            sleep 1
        fi
    else
        echo "The container $DROID does not exist."

        # Create and start the container if it does not exist
        docker run -itd --rm \
            --name "$DROID" \
            --privileged \
            -p 5552:5555 \
            -p 5900:5900 \
            -v /opt/redroid/data:/data \
            redroid/redroid:11.0.0_litegapps_ndk_magisk_widevine \
            androidboot.redroid_width=1600 \
            androidboot.redroid_height=1600 \
            androidboot.redroid_dpi=480 \
            redroid.fps=60 \
            redroid.gpu.mode=guest \
            redroid.vncserver=1 \
            ro.product.cpu.abilist=x86_64,arm64-v8a,x86,armeabi-v7a,armeabi \
            ro.product.cpu.abilist64=x86_64,arm64-v8a \
            ro.product.cpu.abilist32=x86,armeabi-v7a,armeabi \
            ro.dalvik.vm.isa.arm=x86 \
            ro.dalvik.vm.isa.arm64=x86_64 \
            ro.enable.native.bridge.exec=1 \
            ro.dalvik.vm.native.bridge=libndk_translation.so \
            ro.ndk_translation.version=0.2.2

    fi

    # display
    # escrcpy

else
    echo "Android phone connected: $PHONE"
    # orientation
    adb shell settings put system accelerometer_rotation 0  #disable auto-rotate
    adb shell settings put system user_rotation 3  # 270° clockwise
fi

# display
until
scrcpy --serial 127.0.0.1:5552 --video-codec=h264 --video-encoder=OMX.google.h264.encoder \
    --audio-codec=aac --audio-encoder=OMX.google.aac.encoder
# --max-size 1920 --window-borderless
# scrcpy -w --max-size 1600 --no-mouse-hover --window-borderless --window-y 0 # -S screen off save power
do

    # connect
    adb kill-server

    sleep 1
    adb connect 127.0.0.1:5552

    echo "Connect ... ${GREEN} ✔ ${NC}"
done
