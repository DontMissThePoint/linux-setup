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
    [[ -t 0 ]] && { read -t 10 -n 2 -p $'\e[1;32mInstall lobster (stream hollywood movies)? [y/n] (default: '"$default"$')\e[0m\n' resp || resp=$default ; }
  fi
  response=`echo $resp | sed -r 's/(.*)$/\1=/'`

  if [[ $response =~ ^(y|Y)=$ ]]
  then

    toilet Installing lobster

    # ueberzug
    cd /tmp
    sudo apt install -y libssl-dev libvips-dev libsixel-dev libchafa-dev libtbb-dev libxcb-res0-dev
    [ -e ueberzugpp ] && rm -rf ueberzugpp
    git clone https://github.com/jstkdng/ueberzugpp.git
    cd ueberzugpp
    mkdir build && cd build
    cmake -DCMAKE_BUILD_TYPE=Release ..
    cmake --build .
    sudo cp -f ueberzug /usr/local/bin/ueberzug
    sudo ln -sf /usr/local/bin/ueberzug /usr/bin/ueberzugpp

    # bt client
    sudo apt install -y transmission transmission-cli

    # lobster
    sudo curl -sL github.com/justchokingaround/lobster/raw/main/lobster.sh -o /usr/local/bin/lobster &&
    sudo chmod +x /usr/local/bin/lobster
    touch $HOME/.local/share/lobster/lobster_history.txt

    # libg-fzf
    echo "Adding Library Genesis.."
    sudo curl -sL https://raw.githubusercontent.com/mrishu/libg-fzf/main/libg -o /usr/local/bin/libg &&
    sudo chmod +x /usr/local/bin/libg

    # config
    mkdir -p ~/.config/lobster ~/.config/libg
    cp -f "$APP_PATH/lobster_config.txt" ~/.config/lobster/lobster_config.txt
    cp -f "$APP_PATH/libg.sh" ~/.config/libg/libg.sh

    break
  elif [[ $response =~ ^(n|N)=$ ]]
  then
    break
  else
    echo " What? \"$resp\" is not a correct answer. Try y+Enter."
  fi
done
