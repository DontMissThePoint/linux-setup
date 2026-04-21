#!/bin/sh

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

            # Start the container if it is not running
            docker start "$DROID" || echo "OK.."
        fi
    else
        echo "The container $DROID does not exist."

        # Create and start the container if it does not exist
        docker run -d --name "$DROID" redroid11 || echo "OK.."
    fi

    # Wait for the container
    echo "Waiting for ReDroid to boot..."
    sleep 5

    # Connect
    adb connect localhost:5556
else
    echo "Android phone connected: $PHONE"
    # orientation
    adb shell settings put system accelerometer_rotation 0  #disable auto-rotate
    adb shell settings put system user_rotation 3  # 270° clockwise

fi

# connect
# adb connect localhost:5556 || echo "OK."

until
adb connect localhost:5556
do
    sleep 1
    echo -e "Verifying... ${RED} ✔ ${NC}"
    scrcpy -w --video-codec=h264 --video-encoder=OMX.google.h264.encoder \
        --audio-codec=aac --audio-encoder=OMX.google.aac.encoder \
        --max-size 1920 --window-borderless
    # scrcpy -w --max-size 1600 --no-mouse-hover --window-borderless --window-y 0 # -S screen off save power

done
