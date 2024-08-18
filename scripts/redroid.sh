#!/bin/sh

# Start the container
cd ~/VirtualMachines/Android-Docker
sudo docker compose up -d

# Google Play may display “Device not verified”.
# Execute the following commands to obtain the Android device ID, go to Google website to register the device, wait 30 minutes and then restart the Redroid container. Then you can log in to Google Play.

# adb -s localhost:5555 root

# Register
# adb -s localhost:5555 shell 'sqlite3 /data/data/com.google.android.gsf/databases/gservices.db \
#  "select * from main where name = \"android_id\";"'

# How to install APK on ReDroid
# adb -s localhost:5555 install "jp.naver.line.android.apk"

# scrcpy-web
sudo docker start `docker ps -a | grep 'scrcpy-web' | awk '{print $1}'` || \
sudo docker run -itd --privileged -p 8000:8000/tcp emptysuns/scrcpy-web

# Connect to android
sudo docker exec -it scrcpy-web adb connect "$(hostname -I | awk '{print $1}')":11101

until scrcpy --tcpip="$(hostname -I | awk '{print $1}')":11101 --audio-codec=raw
do
  echo Connection refused, retrying in 10 seconds...
  sleep 10
done

# Open your browser,and open your_ip:8000. Click on the H264 Converter

# Pull up from the bottom of the screen
