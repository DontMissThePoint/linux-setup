#!/bin/sh

# start the container.
# create if it does not exist
DROID="redroid-android"

# image
docker image rm redroid/redroid:11.0.0_litegapps_ndk_magisk_widevine ||
docker stop "$DROID"

# Start the container if it is not running
echo "Waiting for ReDroid to resume..."

# password: redroid-android
sudo systemctl daemon-reload
sudo systemctl restart docker

# env
cd "$GIT_PATH"/linux-setup/submodules/"$DROID"
python3 -m venv venv
venv/bin/pip install -r requirements.txt

# liteapps, magisk
venv/bin/python3 redroid.py -a 11.0.0 -lg -mnw

# reset
git reset --hard
git submodule sync --recursive
git submodule update --init --force --recursive
git clean -ffdx

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
    ro.dalvik.vm.native.bridge=libndk_translation.so

# enable debug
# docker exec -it redroid-android sh
# logcat
# dmesg -T
sleep 3
