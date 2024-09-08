#!/bin/sh

# host
IP_ADDRESS="$(hostname -I | awk '{print $1}')":11101

# start the container
cd ~/VirtualMachines/Android-Docker
docker compose up -d

# scrcpy-web
until docker run -itd --privileged --name scrcpy-web -p 8000:8000/tcp emptysuns/scrcpy-web:v0.1
do
  # retry
  echo Connection refused, retrying in 10 seconds...
  docker rm -f `docker ps -a | grep 'scrcpy-web' | awk '{print $1}'`
  sleep 10
done


# connect to android
docker exec -it scrcpy-web adb connect $IP_ADDRESS

# wireless display
(scrcpy --tcpip=$IP_ADDRESS --audio-codec=raw &)

# options
adb -s $IP_ADDRESS shell settings put system accelerometer_rotation 0  #disable auto-rotate
adb -s $IP_ADDRESS shell settings put system user_rotation 0  # 3 => 270° clockwise

# gps
# adb -s $IP_ADDRESS shell settings put global development_settings_enabled 1
adb -s $IP_ADDRESS shell settings put secure location_providers_allowed +gps,network

# mock
# adb -s $IP_ADDRESS emu geo fix [longitude] [latitude] [altitude]
adb -s $IP_ADDRESS shell appops set com.lexa.fakegps android:mock_location allow
adb -s $IP_ADDRESS shell settings put secure location_mode 3 # 0 => disable

# service
adb -s $IP_ADDRESS shell am start-foreground-service com.lexa.fakegps/.FakeGPSService

# 3rd-party apps list
# adb -s $IP_ADDRESS shell pm list packages -3

# activities
# adb shell dumpsys package | grep -Eo "^[[:space:]]+[0-9a-f]+[[:space:]]+com.lexa.fakegps/[^[:space:]]+" | grep -oE "[^[:space:]]+$"
# adb -s $IP_ADDRESS shell monkey --pct-syskeys 0 -p com.lexa.fakegps -c android.intent.category.LAUNCHER 1
# adb -s $IP_ADDRESS shell am start -a android.intent.action.MAIN -n com.lexa.fakegps/.ui.Main &

# Open your browser,and open your_ip:8000. Click on the H264 Converter

# Pull up from the bottom of the screen
