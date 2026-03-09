#!/bin/sh

# server
adb start-server

docker run -itd --rm \
    --name redroid12 \
    --pull always \
    --privileged \
    --restart no \
    -p 5556:5555 \
    -e TZ=Etc/GMT-3 \
    -v /opt/redroid/data:/data \
    redroid/redroid:12.0.0_litegapps_ndk_magisk_widevine \
    androidboot.redroid_width=1600 \
    androidboot.redroid_height=1600 \
    androidboot.redroid_dpi=480 \
    androidboot.redroid_fps=60 \
    androidboot.redroid_gpu_mode=guest \
    ro.product.cpu.abilist0=x86_64,arm64-v8a,x86,armeabi-v7a,armeabi \
    ro.product.cpu.abilist64=x86_64,arm64-v8a \
    ro.product.cpu.abilist32=x86,armeabi-v7a,armeabi \
    ro.dalvik.vm.isa.arm=x86 \
    ro.dalvik.vm.isa.arm64=x86_64 \
    ro.enable.native.bridge.exec=1 \
    ro.dalvik.vm.native.bridge=libndk_translation.so \
    ro.ndk_translation.version=0.2.2

# connect
sudo adb connect localhost:5556
