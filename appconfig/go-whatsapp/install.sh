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
[ "$var" = "18.04" ] && export BEAVER=1
[ "$var" = "20.04" ] && export FOCAL=1

default=y
while true; do
  if [[ "$unattended" == "1" ]]
  then
    resp=$default
  else
    [[ -t 0 ]] && { read -t 10 -n 2 -p $'\e[1;32mInstall whatsapp chat client (pidgin, go-whatsapp)? [y/n] (default: '"$default"$')\e[0m\n' resp || resp=$default ; }
  fi
  response=`echo $resp | sed -r 's/(.*)$/\1=/'`

  if [[ $response =~ ^(y|Y)=$ ]]
  then

    toilet Setting up go-whatsapp

    sudo apt install -y finch pidgin pkg-config cmake make golang gcc libgdk-pixbuf2.0-dev libopusfile-dev libpurple-bin libpurple-dev

    # config
    mkdir -p ~/.purple/plugins
    
    if [ -n "$BEAVER" ] || [ -n "$FOCAL" ]; then
      cp -f $APP_PATH/libwhatsmeow.so ~/.purple/plugins/libwhatsmeow.so
    else
      # compile from sources
      cd /tmp && rm -fr purple-gowhatsapp
      git clone https://github.com/hoehermann/purple-gowhatsapp.git
      git submodule update --init
      mkdir build && cd build
      cmake ..
      cmake --build .
      sudo make install/strip

      # whatsapp
      sudo cp -f /usr/lib/purple-2/libwhatsmeow.so ~/.purple/plugins/libwhatsmeow.so
      sudo chown $USER: ~/.purple/plugins/libwhatsmeow.so
    fi

    # prefs
    echo "Setup account with 256782564488@s.whatsapp.net"

    break
  elif [[ $response =~ ^(n|N)=$ ]]
  then
    break
  else
    echo " What? \"$resp\" is not a correct answer. Try y+Enter."
  fi
done
