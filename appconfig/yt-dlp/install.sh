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
	  [[ -t 0 ]] && { read -t 10 -n 2 -p $'\e[1;32mInstall yt-dlp (videos from youtube in terminal)? [y/n] (default: '"$default"$')\e[0m\n' resp || resp=$default ; }
  fi
  response=`echo $resp | sed -r 's/(.*)$/\1=/'`

  if [[ $response =~ ^(y|Y)=$ ]]
  then

    toilet Installing yt-dlp

    # opencv
    sudo apt install -y libopencv-dev python3-opencv

    # ueberzug
    cd /tmp
    sudo apt install -y libssl-dev libvips-dev libsixel-dev libchafa-dev libtbb-dev libxcb-res0-dev
    [ -e ueberzugpp ] && rm -rf ueberzugpp
    git clone https://github.com/jstkdng/ueberzugpp.git
    cd ueberzugpp
    mkdir build && cd build
    cmake -DCMAKE_BUILD_TYPE=Release ..
    cmake --build .

    # ytfzf
    python3 -m pip install -U yt-dlp
    cd /tmp
    [ -e ytfzf ] && rm -rf ytfzf
    git clone https://github.com/pystardust/ytfzf
    cd ytfzf
    sudo make install doc

    # lobster
    sudo curl -sL github.com/justchokingaround/lobster/raw/main/lobster.sh -o /usr/local/bin/lobster &&
    sudo chmod +x /usr/local/bin/lobster

    # xnview
    if [ -n "$JAMMY" ]; then
      sudo apt install -y libgdk-pixbuf2.0-0
    fi
    wget https://download.xnview.com/XnViewMP-linux-x64.deb -O $APP_PATH/XnViewMP-linux-x64.deb

    sudo dpkg -i $APP_PATH/XnViewMP-linux-x64.deb
    rm -f $APP_PATH/XnViewMP-linux-x64.deb

    # config
    mkdir -p ~/.config/xnviewmp
    cp $APP_PATH/style_sheet.qss ~/.config/xnviewmp/style_sheet.qss

    mkdir -p ~/.config/ytfzf
    cp $APP_PATH/conf.sh ~/.config/ytfzf/conf.sh

    break
  elif [[ $response =~ ^(n|N)=$ ]]
  then
    break
  else
    echo " What? \"$resp\" is not a correct answer. Try y+Enter."
  fi
done
