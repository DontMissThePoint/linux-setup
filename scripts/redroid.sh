#!/bin/sh

# modules
sudo modprobe binder_linux devices="binder,hwbinder,vndbinder"
# sudo modprobe ashmem_linux

# deamon
cd ~/VirtualMachines/Android-Docker
docker compose up -d

# Connect to android: scrcpy-web
# docker run -itd --privileged -p 8000:8000/tcp emptysuns/scrcpy-web:v0.1 #--name scrcpy-web
docker start `docker ps -a | grep 'scrcpy-web' | awk '{print $1}'`
# docker exec -it scrcpy-web adb connect "$(hostname -I | awk '{print $1}')":11101

scrcpy --tcpip="$(hostname -I | awk '{print $1}')":11101 --audio-codec=raw

# Open your browser,and open your_ip:8000. Click on the H264 Converter

# Pull up from the bottom of the screen
