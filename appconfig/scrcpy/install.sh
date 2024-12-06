#!/bin/bash

set -e

trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
trap 'echo "$0: \"${last_command}\" command failed with exit code $?"' ERR

# get the path to this script
APP_PATH=`dirname "$0"`
APP_PATH=`( cd "$APP_PATH" && pwd )`

unattended=0
subinstall_params=""
for param in "$@"
do
  echo $param
  if [ $param="--unattended" ]; then
    echo "installing in unattended mode"
    unattended=1
    subinstall_params="--unattended"
  fi
done

default=y
while true; do
  if [[ "$unattended" == "1" ]]
  then
    resp=$default
  else
    [[ -t 0 ]] && { read -t 10 -n 2 -p $'\e[1;32mInstall scrcpy? [y/n] (default: '"$default"$')\e[0m\n' resp || resp=$default ; }
  fi
  response=`echo $resp | sed -r 's/(.*)$/\1=/'`

  if [[ $response =~ ^(y|Y)=$ ]]
  then

    sudo apt install -y libsdl2-2.0-0 adb fastboot wget \
    	gcc git pkg-config meson ninja-build libsdl2-dev \
    	libavcodec-dev libavdevice-dev libavformat-dev libavutil-dev \
    	libswresample-dev libusb-1.0-0 libusb-1.0-0-dev libavformat-dev libavutil-dev

    # latest adb
    cd /tmp
    wget https://dl.google.com/android/repository/platform-tools-latest-linux.zip
    unzip \platform-tools-latest-linux.zip
    sudo cp platform-tools/adb /usr/lib/android-sdk/platform-tools/
    sudo cp platform-tools/fastboot /usr/lib/android-sdk/platform-tools/

    # check that it worked with:

    # adb --version
    # fastboot --version

    toilet Installing scrcpy -t --filter metal -f smmono12

    # install lolcat
    cd $APP_PATH/../../submodules/scrcpy
    ./install_release.sh

    # Screencast
    # scrcpy -w --show-touches --window-width 2160 --window-height 920 --window-borderless -s '<DEVICE SERIAL>'

    # re-droid
    echo "Setup redroid..."
    sudo apt install -y android-platform-tools-base lzip linux-modules-extra-`uname -r`
    sudo modprobe binder_linux devices="binder,hwbinder,vndbinder"

    cd /tmp
    [ -e redroid-script ] && rm -rf redroid-script
    git clone https://github.com/ayasa520/redroid-script
    cd redroid-script
    /usr/bin/python3 -m venv venv
    venv/bin/pip install -r requirements.txt

    # GApps
    # venv/bin/python3 redroid.py -a 11.0.0 -gmnw
    venv/bin/python3 redroid.py -a 11.0.0 -gn

    mkdir -p ~/VirtualMachines/Android-Docker
    cp -f $APP_PATH/docker-compose.yml ~/VirtualMachines/Android-Docker

    # ID
    # Register
    # Execute the following commands to obtain the Android device ID,

    IP_ADDRESS=`hostname -I | awk '{print $1}'`
    adb -s $IP_ADDRESS:11101 root

    adb -s $IP_ADDRESS:11101 shell 'sqlite3 /data/data/com.google.android.gsf/databases/gservices.db \
     "select * from main where name = \"android_id\";"'
    echo "https://www.google.com/android/uncertified go to Google website to register the device"

    # modules load automatically
    sudo cp -f $APP_PATH/redroid.conf /etc/modules-load.d/redroid.conf
    echo "Wait 30 minutes"
    echo "Restart the Redroid container. Then log in to Google Play"

    break
  elif [[ $response =~ ^(n|N)=$ ]]
  then
    break
  else
    echo " What? \"$resp\" is not a correct answer. Try y+Enter."
  fi
done
