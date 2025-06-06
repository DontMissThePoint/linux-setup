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
[ "$var" = "24.04" ] && export NOBLE=1

default=y
while true; do
  if [[ "$unattended" == "1" ]]
  then
    resp=$default
  else
    [[ -t 0 ]] && { read -t 5 -n 2 -p $'\e[1;32mInstall urxvt? [y/n] (default: '"$default"$')\e[0m\n' resp || resp=$default ; }
  fi
  response=`echo $resp | sed -r 's/(.*)$/\1=/'`

  if [[ $response =~ ^(y|Y)=$ ]]
  then

    toilet Settingup urxvtc -t -f future

    # install urvxt
    if [ -n "$NOBLE" ];
    then
      sudo apt-get -y install rxvt-unicode
    else
      sudo apt-get -y install rxvt-unicode-256color rxvt-ml
    fi

    # xseturgent
    cd /tmp
    [ -e xseturgent ] && rm -rf xseturgent
    git clone https://github.com/lpenz/xseturgent
    cd xseturgent && mkdir -p build && cd build && cmake ..
    make -s -j8
    sudo make install

    EXTENSION_PATH="/usr/lib/x86_64-linux-gnu/urxvt/perl"
    sudo mkdir -p $EXTENSION_PATH

    # link extensions
    for file in `ls $APP_PATH/extensions/`; do
      sudo ln -sf $APP_PATH/extensions/$file $EXTENSION_PATH/$file
    done

    # default
    sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator /usr/bin/urxvtc 100
    sudo update-alternatives --set x-terminal-emulator /usr/bin/urxvtc

    break
  elif [[ $response =~ ^(n|N)=$ ]]
  then
    break
  else
    echo " What? \"$resp\" is not a correct answer. Try y+Enter."
  fi
done
