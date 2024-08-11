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
	  [[ -t 0 ]] && { read -t 10 -n 2 -p $'\e[1;32mInstall yt-dlp (videos, image galleries, collections)? [y/n] (default: '"$default"$')\e[0m\n' resp || resp=$default ; }
  fi
  response=`echo $resp | sed -r 's/(.*)$/\1=/'`

  if [[ $response =~ ^(y|Y)=$ ]]
  then

    toilet Installing yt-dlp

    # opencv
    sudo apt install -y libopencv-dev python3-opencv intel-media-va-driver-non-free

    # yt-dlp; gallery-dl
    /usr/bin/python3 -m pip install -U yt-dlp gallery-dl

    # ytfzf
    cd /tmp
    [ -e ytfzf ] && rm -rf ytfzf
    git clone https://github.com/pystardust/ytfzf
    cd ytfzf
    sudo make install doc

    # config
    echo "Configuring..."
    mkdir -p ~/.config/yt-dlp ~/.config/ytfzf ~/.config/gallery-dl ~/.config/xnviewmp
    pv $APP_PATH/style_sheet.qss > ~/.config/xnviewmp/style_sheet.qss
    pv $APP_PATH/yt-dlp.conf > ~/.config/yt-dlp/yt-dlp.conf
    pv $APP_PATH/conf.sh > ~/.config/ytfzf/conf.sh
    pv $APP_PATH/config.json > ~/.config/gallery-dl/config.json
    echo "Done."

    break
  elif [[ $response =~ ^(n|N)=$ ]]
  then
    break
  else
    echo " What? \"$resp\" is not a correct answer. Try y+Enter."
  fi
done
