#!/bin/sh

# modules
sudo modprobe binder_linux devices="binder,hwbinder,vndbinder"

# deamon
cd $GIT_PATH/VirtualMachines/Android-Docker
sudo docker compose up -d

# You can obtain shell via
# $ docker exec -it <container> sh
# connect to adbd after container booted

# Connect to the local ReDroid using ADB
sudo adb connect localhost:5555

# Run Scrcpy to connect to the Android desktop
scrcpy -w --show-touches --window-borderless --window-y 0 -s localhost:5555 --audio-codec=raw

# Stop container
# sudo ps awx | grep docker | awk '{print $1}' | xargs kill -9
