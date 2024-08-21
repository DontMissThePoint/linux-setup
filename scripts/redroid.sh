#!/bin/sh

# Start the container
cd ~/VirtualMachines/Android-Docker
sudo docker compose up -d

# scrcpy-web
sudo docker start `docker ps -a | grep 'scrcpy-web' | awk '{print $1}'` || \
sudo docker run -itd --privileged -p 8000:8000/tcp emptysuns/scrcpy-web:v0.1

# Connect to android
sudo docker exec -it scrcpy-web adb connect "$(hostname -I | awk '{print $1}')":11101

until scrcpy --tcpip="$(hostname -I | awk '{print $1}')":11101 --audio-codec=raw
do
  echo Connection refused, retrying in 10 seconds...
  sleep 10
done

# Open your browser,and open your_ip:8000. Click on the H264 Converter

# Pull up from the bottom of the screen
