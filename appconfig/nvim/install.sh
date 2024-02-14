#!/bin/bash

set -e

trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
trap 'echo "$0: \"${last_command}\" command failed with exit code $?"' ERR

# get the path to this script
APP_PATH=`dirname "$0"`
APP_PATH=`( cd "$APP_PATH" && pwd )`
CONFIG="$HOME/.config/nvim"

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
    [[ -t 0 ]] && { read -t 10 -n 2 -p $'\e[1;32mInstall neovim? [y/n] (default: '"$default"$')\e[0m\n' resp || resp=$default ; }
  fi
  response=`echo $resp | sed -r 's/(.*)$/\1=/'`

  if [[ $response =~ ^(y|Y)=$ ]]
  then

    toilet Installing neovim

    sudo apt-get -y remove neovim* || echo ""

    sudo apt-get -y install ninja-build gettext cmake unzip curl

    # compile neovim from sources
    # cd $APP_PATH/../../submodules/nvim
    rm -fr /tmp/nvim && mkdir /tmp/nvim && cd /tmp/nvim
    git clone https://github.com/neovim/neovim
    cd neovim
    make -j8 CMAKE_BUILD_TYPE=RelWithDebInfo \
    CMAKE_INSTALL_PREFIX=/usr/bin/nvim

    cd build && cpack -G DEB && sudo dpkg -i nvim-linux64.deb

    # smartGit; smartSynchronize, deepGit
    echo "Setup syntevo tools."
    aria2c -x16 -s16 https://www.syntevo.com/downloads/smartgit/smartgit-23_1_1.deb
    aria2c -x16 -s16 https://www.syntevo.com/downloads/smartsynchronize/smartsynchronize-4_5_0.deb
    aria2c -x16 -s16 https://www.syntevo.com/downloads/deepgit/deepgit-4_4.deb

    # syntevo
    sudo dpkg -i *.deb || sudo apt install -f

    # config
    mkdir -p "$CONFIG"

    sudo -H pip3 install wheel

    sudo -H pip3 install neovim
    sudo -H pip3 install neovim-remote

    # Nvchad
    git clone https://github.com/NvChad/NvChad "$CONFIG" --depth 1 && nvim

    # symlink neovim settings
    #ln -sf $APP_PATH/../nvim/init.vim ~/.config/nvim/init.vim
    #ln -sf $APP_PATH/../vim/dotvim/* ~/.config/nvim/

    break
  elif [[ $response =~ ^(n|N)=$ ]]
  then
    break
  else
    echo " What? \"$resp\" is not a correct answer. Try y+Enter."
  fi
done
