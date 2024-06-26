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

var=`lsb_release -r | awk '{ print $2 }'`
[ "$var" = "20.04" ] && export FOCAL=1
[ "$var" = "22.04" ] && export JAMMY=1

default=y
while true; do
  if [[ "$unattended" == "1" ]]
  then
    resp=$default
  else
	  [[ -t 0 ]] && { read -t 10 -n 2 -p $'\e[1;32mInstall yt-dlp (videos, image galleries, collections)? [y/n] (default: '"$default"$')\e[0m\n' resp || resp=$default ; }
  fi
  response=`echo $resp | sed -r 's/(.*)$/\1=/'`

  if [[ $response =~ ^(y|Y)=$ ]]
  then

    toilet Installing yt-dlp

    # opencv
    sudo apt install -y libopencv-dev python3-opencv

    # yt-dlp; gallery-dl
    /usr/bin/python3 -m pip install -U yt-dlp gallery-dl

    # ytfzf
    cd /tmp
    [ -e ytfzf ] && rm -rf ytfzf
    git clone https://github.com/pystardust/ytfzf
    cd ytfzf
    sudo make install doc

    # xnview
    echo "Installing XnViewMP."

    if [ -n "$JAMMY" ]; then
      sudo apt install -y libgdk-pixbuf2.0-0
    fi
    aria2c -c -j 8 -x 16 -s 16 -k 1M -d "$APP_PATH" https://download.xnview.com/XnViewMP-linux-x64.deb

    sudo dpkg -i $APP_PATH/XnViewMP-linux-x64.deb
    rm -f $APP_PATH/XnViewMP-linux-x64.deb

    # config
    echo "Configuring..."
    mkdir -p ~/.config/yt-dlp ~/.config/ytfzf ~/.config/gallery-dl ~/.config/xnviewmp
    pv $APP_PATH/style_sheet.qss > ~/.config/xnviewmp/style_sheet.qss
    pv $APP_PATH/yt-dlp.conf > ~/.config/yt-dlp/yt-dlp.conf
    pv $APP_PATH/conf.sh > ~/.config/ytfzf/conf.sh
    pv $APP_PATH/config.json > ~/.config/gallery-dl/config.json

    break
  elif [[ $response =~ ^(n|N)=$ ]]
  then
    break
  else
    echo " What? \"$resp\" is not a correct answer. Try y+Enter."
  fi
done
