#!/bin/sh

DROID="redroid-android"
OPTIONS="11.0.0\n15.0.0"
VAR=$(printf "$OPTIONS" | fzf --prompt="Select android image: ")

# image
if [ "$VAR" = "" ]; then
    echo "Exiting ..." # handle empty (e.g. ESC)
    exit 1
fi

# Start the container if it is not running
echo "Waiting for ReDroid to resume..."
docker restart "$DROID" || num=$(docker image ls | grep -c "$VAR")

# android

# bridge
if [ "$VAR" = "11.0.0" ]; then

    IMAGE="$VAR"_litegapps_ndk_magisk_widevine
    BRIDGE=libndk_translation.so
    STORAGE="/opt/redroid/data"

    if [ "$num" -lt "1" ]; then

        # redroid
        sudo systemctl daemon-reload
        sudo systemctl restart docker

        # env
        cd "$GIT_PATH"/linux-setup/submodules/"$DROID"
        python3 -m venv venv
        venv/bin/pip install -r requirements.txt

        # liteapps, magisk
        venv/bin/python3 redroid.py -a "$VAR" -lg -mnw

        # reset
        git reset --hard
        git submodule sync --recursive
        git submodule update --init --force --recursive
        git clean -ffdx

    fi

    # container
    docker run -itd --rm --privileged \
        --name "$DROID" \
        --memory 2g \
        --memory-swap 6g \
        -p 5552:5555/tcp \
        -p 5900:5900/udp \
        -v "$STORAGE":/data \
        redroid/redroid:"$IMAGE" \
        androidboot.redroid_width=1600 \
        androidboot.redroid_height=1600 \
        androidboot.redroid_dpi=480 \
        androidboot.redroid_fps=60 \
        androidboot.redroid_gpu_mode=host \
        androidboot.use_memfd=1 \
        redroid.vncserver=1 \
        ro.product.cpu.abilist=x86_64,arm64-v8a,x86,armeabi-v7a,armeabi \
        ro.product.cpu.abilist64=x86_64,arm64-v8a \
        ro.product.cpu.abilist32=x86,armeabi-v7a,armeabi \
        ro.dalvik.vm.isa.arm=x86 \
        ro.dalvik.vm.isa.arm64=x86_64 \
        ro.enable.native.bridge.exec=1 \
        ro.vendor.enable.native.bridge.exec=1 \
        ro.vendor.enable.native.bridge.exec64=1 \
        ro.dalvik.vm.native.bridge="$BRIDGE"

else

    # deamon
    cd ~/VirtualMachines/Redroid-Android
    docker compose up -d
fi

#
#### enable debug ####
# docker exec -it redroid-android sh
# logcat
# dmesg -T
sleep 1
