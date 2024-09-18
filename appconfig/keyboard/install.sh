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
    [[ -t 0 ]] && { read -t 10 -n 2 -p $'\e[1;32mInstall modified keyboard rules (qwerty, capslock=esc)? [y/n] (default: '"$default"$')\e[0m\n' resp || resp=$default ; }
  fi
  response=`echo $resp | sed -r 's/(.*)$/\1=/'`

  if [[ $response =~ ^(y|Y)=$ ]]
  then

    toilet Setting up keyboard

    # copy modified keyboard default file
    sudo cp "$APP_PATH/keyboard" /etc/default/keyboard

    # xcape
    sudo apt install -y gcc make pkg-config libx11-dev libxtst-dev libxi-dev libx11-dev libxcomposite-dev libxdamage-dev libxrender-dev
    cd /tmp
    [ -e xcape ] && rm -rf xcape
    git clone https://github.com/alols/xcape.git
    cd xcape
    make -j8
    sudo make install

    # find-cursor
    cd /tmp
    [ -e find-cursor ] && rm -rf find-cursor
    git clone https://github.com/arp242/find-cursor
    cd find-cursor
    make -j8
    sudo make install

    break
  elif [[ $response =~ ^(n|N)=$ ]]
  then
    break
  else
    echo " What? \"$resp\" is not a correct answer. Try y+Enter."
  fi
done
