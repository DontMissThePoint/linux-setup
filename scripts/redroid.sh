#!/bin/sh

# host IP address
deviceID="$(hostname -I | awk '{print $1}')":11101

# start the container
cd ~/VirtualMachines/Android-Docker
docker compose up -d

# scrcpy-web
until docker run -itd --privileged --name scrcpy-web -p 8000:8000/tcp emptysuns/scrcpy-web:v0.1
do
  # retry
  docker rm -f `docker ps -a | grep 'scrcpy-web' | awk '{print $1}'`
  echo Connection refused, retrying in 1 seconds
  sleep 1
done

# connect to android
docker exec -it scrcpy-web adb connect $deviceID

# wireless display
(scrcpy --tcpip=$deviceID --audio-codec=raw --no-cleanup &)
sleep 5

# options
adb shell settings put system accelerometer_rotation 0  #disable auto-rotate
adb shell settings put system user_rotation 0  # 3 => 270° clockwise

# gps
# adb shell settings put global development_settings_enabled 1
adb shell settings put secure location_providers_allowed +gps,network

# mock
# adb emu geo fix [longitude] [latitude] [altitude]
adb shell appops set com.lexa.fakegps android:mock_location allow
adb shell settings put secure location_mode 3 # 0 => disable

# service
adb shell am start-foreground-service com.lexa.fakegps/.FakeGPSService

# 3rd-party apps list
# adb shell pm list packages -3

# activities
# adb shell dumpsys package | grep -Eo "^[[:space:]]+[0-9a-f]+[[:space:]]+com.lexa.fakegps/[^[:space:]]+" | grep -oE "[^[:space:]]+$"
# adb shell monkey --pct-syskeys 0 -p com.lexa.fakegps -c android.intent.category.LAUNCHER 1
# adb shell am start -a android.intent.action.MAIN -n com.lexa.fakegps/.ui.Main &

# Open your browser,and open your_ip:8000. Click on the H264 Converter

# Pull up from the bottom of the screen
