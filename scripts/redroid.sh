#!/bin/sh

export DROID="redroid-android"
OPTIONS="15.0.0\n11.0.0"
VAR=$(printf "$OPTIONS" | fzf --prompt="Select android image: ")
export IMG="$HOME/VirtualMachines/Android-Docker"

# image
if [ "$VAR" = "" ]; then
    echo "Exiting ..."
    exit 1
fi

# android
num=$(docker image ls | grep -c "$VAR")

if [ "$num" -lt "1" ]; then
    sudo systemctl daemon-reload
    sudo systemctl restart docker

    cd "$GIT_PATH"/linux-setup/submodules/"$DROID"
    python3 -m venv venv
    venv/bin/pip install -r requirements.txt
    venv/bin/python3 redroid.py -a "$VAR" -lg -mnw

    git reset --hard
    git submodule sync --recursive
    git submodule update --init --force --recursive
    git clean -ffdx
fi

# Export runtime variables
export STORAGE="$IMG/$VAR"
if [ "$VAR" = "11.0.0" ]; then
    export IMAGE="redroid/redroid:${VAR}_litegapps_ndk_magisk_widevine"
    export BRIDGE="libndk_translation.so"
else
    export IMAGE="kylindemons/redroid:${VAR}_amd64-GApps-Magisk-latest"
    export BRIDGE="libndk_translation.so"
fi

# deamon
cd "$IMG" >/dev/null
echo "Booting redroid with Ad-Blocking..."
# docker compose down >/dev/null 2>&1
docker compose up -d

#### enable debug ####
# docker exec -it redroid-android sh
# logcat
# dmesg -T
sleep 1
