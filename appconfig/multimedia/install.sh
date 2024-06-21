#!/bin/bash

set -e

trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
trap 'echo "$0: \"${last_command}\" command failed with exit code $?"' ERR

# get the path to this script
APP_PATH=`dirname "$0"`
APP_PATH=`( cd "$APP_PATH" && pwd )`
CONFIG="$HOME/.config/mpv"

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

var=`lsb_release -r | awk '{ print $2 }'`
[ "$var" = "20.04" ] && export FOCAL=1
[ "$var" = "22.04" ] && export JAMMY=1

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

    # ffmpeg
    cd /tmp
    wget -c -O ~/.local/bin/alass https://github.com/kaegi/alass/releases/download/v2.0.0/alass-linux64
    wget -c https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-amd64-static.tar.xz
    tar -xf ffmpeg-release-amd64-static.tar.xz
    cp ffmpeg-7.0.1-amd64-static/ff* ~/.local/bin
    sudo chmod 755 ~/.local/bin/ffmpeg
    sudo chmod 755 ~/.local/bin/ffprobe
    sudo chmod 755 ~/.local/bin/alass


    # use in pdfpc to play videos
    sudo apt-get -y install gstreamer1.0-libav libxpresent1

    # for video, photo, audio, ..., viewing and editing
    sudo pip install subliminal ffsubsync
    sudo apt-get -y install gimp screenkey vlc audacity rawtherapee pavucontrol

    # mpv
    echo "Installing MPV"
    if [ -n "$FOCAL" ] || [ -n "$JAMMY" ]; then
      wget -c -P "$APP_PATH" https://apt.fruit.je/ubuntu/jammy/mpv/mpv_0.38.0+fruit.1_amd64.deb
      sudo dpkg -i $APP_PATH/mpv_0.38.0+fruit.1_amd64.deb
      rm -f $APP_PATH/mpv_0.38.0+fruit.1_amd64.deb
    else
      sudo apt install -y mpv
    fi

    # high-quality mpv
    echo "Installing... 🎥 High-quality configuration for mpv"
    rm -rf "$CONFIG"
    git clone https://github.com/noelsimbolon/mpv-config "$CONFIG"

    break
  elif [[ $response =~ ^(n|N)=$ ]]
  then
    break
  else
    echo " What? \"$resp\" is not a correct answer. Try y+Enter."
  fi
done
