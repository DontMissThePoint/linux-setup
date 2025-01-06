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
[ "$var" = "22.04" ] && export NOBLE=1

default=y
while true; do
  if [[ "$unattended" == "1" ]]
  then
    resp=$default
  else
    [[ -t 0 ]] && { read -t 10 -n 2 -p $'\e[1;32mInstall nchat (whatsmeow, pidgin, go-whatsapp)? [y/n] (default: '"$default"$')\e[0m\n' resp || resp=$default ; }
  fi
  response=`echo $resp | sed -r 's/(.*)$/\1=/'`

  if [[ $response =~ ^(y|Y)=$ ]]
  then

    toilet Installing nchat -t --filter metal -f smmono12
    sudo apt install -y ccache cmake build-essential gperf help2man libreadline-dev libssl-dev libncurses-dev libncursesw5-dev ncurses-doc zlib1g-dev libsqlite3-dev libmagic-dev golang git html2md

    # nchat
    cd /tmp
    [ -e nchat ] && rm -rf nchat
    git clone https://github.com/d99kris/nchat.git
    cd nchat && mkdir -p build && cd build && cmake ..
    make -s -j8
    sudo make install

    # colors : basic-color, default, espresso, solarized-dark-higher-contrast, tomorrow-night, zenburned
    # catppuccin-mocha, dracula, gruvbox-dark, tokyo-night, zenbones-dark
    cp $(dirname $(which nchat))/../share/nchat/themes/tomorrow-night/* ~/.config/nchat/

    # pidgin
    toilet Setting up go-whatsapp -t -f future
    sudo apt install -y finch pidgin pkg-config cmake make golang gcc libgdk-pixbuf2.0-dev libopusfile-dev libpurple-bin libpurple-dev

    # config
    mkdir -p ~/.purple/plugins

    if [ -n "$BEAVER" ] || [ -n "$NOBLE" ]; then
      pv $APP_PATH/libwhatsmeow.so > ~/.purple/plugins/libwhatsmeow.so
    else
      # go
      sudo rm -rf /usr/local/go
      wget -c https://go.dev/dl/go1.21.6.linux-amd64.tar.gz -O - | sudo tar -xz -C /usr/local
      # wget -c https://buildbot.hehoe.de/purple-whatsmeow/builds/libwhatsmeow.so -P /usr/lib/purple-2/

      EXISTING_GO=`cat ~/.profile 2> /dev/null | grep "go/bin" | wc -l`
      if [ "$EXISTING_GO" == "0" ]; then
        toilet Settingup go -t -f future
        (echo; echo 'export PATH=$PATH:/usr/local/go/bin') >> ~/.profile
      fi
      export PATH=$PATH:/usr/local/go/bin

      # compile from sources

      cd /tmp
      [ -e purple-gowhatsapp ] && rm -rf purple-gowhatsapp
      git clone https://github.com/hoehermann/purple-gowhatsapp.git
      cd purple-gowhatsapp
      git submodule update --init
      mkdir -p build && cd build
      cmake ..
      cmake --build .
      sudo make install/strip

      # whatsapp
      cmake -DPURPLE_DATA_DIR:PATH=~/.local/share -DPURPLE_PLUGIN_DIR:PATH=~/.purple/plugins ..
    fi

    # prefs
    echo "nchat --setup to get started +2567XXXXXXXX"
    echo "Pidgin: Setup account with 2567XXXXXXXX@s.whatsapp.net"

    break
  elif [[ $response =~ ^(n|N)=$ ]]
  then
    break
  else
    echo " What? \"$resp\" is not a correct answer. Try y+Enter."
  fi
done
