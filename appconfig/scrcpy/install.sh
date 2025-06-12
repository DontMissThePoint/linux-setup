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

    toilet Installing scrcpy -t --filter metal -f smmono12
    cd $APP_PATH/../../submodules/scrcpy

    # adb
    sudo apt install -y libsdl2-2.0-0 adb fastboot wget \
    	gcc git pkg-config meson ninja-build libsdl2-dev \
    	libavcodec-dev libavdevice-dev libavformat-dev libavutil-dev \
    	libswresample-dev libusb-1.0-0 libusb-1.0-0-dev libavformat-dev libavutil-dev
    ./install_release.sh

    cd /tmp
    wget https://dl.google.com/android/repository/platform-tools-latest-linux.zip
    unzip \platform-tools-latest-linux.zip
    sudo cp platform-tools/adb /usr/lib/android-sdk/platform-tools/
    sudo cp platform-tools/fastboot /usr/lib/android-sdk/platform-tools/

    # binder
    sudo apt install -y linux-headers-generic android-platform-tools-base lzip linux-modules-extra-`uname -r`
    sudo modprobe binder_linux devices="binder,hwbinder,vndbinder"

    # snd_aloop
    echo 'binder_linux
options binder_linux devices="binder,hwbinder,vndbinder"' | sudo tee /etc/modules-load.d/redroid.conf >/dev/null
    echo "Modules loded successfully"

    break
  elif [[ $response =~ ^(n|N)=$ ]]
  then
    break
  else
    echo " What? \"$resp\" is not a correct answer. Try y+Enter."
  fi
done
