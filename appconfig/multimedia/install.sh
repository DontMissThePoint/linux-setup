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
    [[ -t 0 ]] && { read -t 10 -n 2 -p $'\e[1;32mInstall multimedia support (editors, players, ...)? [y/n] (default: '"$default"$')\e[0m\n' resp || resp=$default ; }
  fi
  response=`echo $resp | sed -r 's/(.*)$/\1=/'`

  if [[ $response =~ ^(y|Y)=$ ]]
  then

    # use in pdfpc to play videos
    sudo apt-get -y install gstreamer1.0-libav

    # for video, photo, audio, ..., viewing and editing
    sudo apt-get -y install gimp screenkey mpv vlc audacity rawtherapee pavucontrol

    # high-quality mpv
    echo "Installing... 🎥 High-quality configuration for mpv media player"
    wget -qO- https://github.com/noelsimbolon/mpv-config/releases/download/v1.0.5/mpv-config-linux.zip | bsdtar --strip-components=1 -xvf- -C ~/.config/mpv

    break
  elif [[ $response =~ ^(n|N)=$ ]]
  then
    break
  else
    echo " What? \"$resp\" is not a correct answer. Try y+Enter."
  fi
done
