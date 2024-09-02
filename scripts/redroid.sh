#!/bin/sh

# get host IP
IP_ADDRESS="$(hostname -I | awk '{print $1}')":11101

# Start the container
cd ~/VirtualMachines/Android-Docker
sudo docker compose up -d

# scrcpy-web
sudo docker start `docker ps -a | grep 'scrcpy-web' | awk '{print $1}'` || \
sudo docker run -itd --privileged -p 8000:8000/tcp emptysuns/scrcpy-web:v0.1

# Connect to android
sudo docker exec -it scrcpy-web adb connect $IP_ADDRESS
adb -s $IP_ADDRESS shell settings put system accelerometer_rotation 0  #disable auto-rotate
adb -s $IP_ADDRESS shell settings put system user_rotation 0  # 3 => 270° clockwise
adb -s $IP_ADDRESS emu geo fix 32.6110218 0.3629101 # [longitude] [latitude] [altitude]

until scrcpy --tcpip=$IP_ADDRESS --audio-codec=raw
do
  # retry
  echo Connection refused, retrying in 10 seconds...
  sleep 10
done

# Open your browser,and open your_ip:8000. Click on the H264 Converter

# Pull up from the bottom of the screen
