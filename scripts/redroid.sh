#!/bin/sh

# modules
sudo modprobe binder_linux devices="binder,hwbinder,vndbinder"

# deamon
cd $GIT_PATH/VirtualMachines/Android-Docker
sudo docker compose up -d

# You can obtain shell via
# $ docker exec -it `docker container ls | grep 'redroid' | awk '{print $1}'` sh

# Connect to the local ReDroid using ADB
adb connect localhost:5555
# adb kill-server

# Run Scrcpy to connect to the Android desktop
scrcpy -s 'localhost:5555' # --audio-codec=raw

# Stop container
# sudo ps awx | grep docker | awk '{print $1}' | xargs kill -9
