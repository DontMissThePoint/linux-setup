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
    [[ -t 0 ]] && { read -t 10 -n 2 -p $'\e[1;32mInstall ranger? [y/n] (default: '"$default"$')\e[0m\n' resp || resp=$default ; }
  fi
  response=`echo $resp | sed -r 's/(.*)$/\1=/'`

  if [[ $response =~ ^(y|Y)=$ ]]
  then

    toilet Installing ranger
    sudo apt-get -y install caca-utils libimage-exiftool-perl w3m w3m-img

    cd $APP_PATH/../../submodules/ranger
    sudo make install

    mkdir -p ~/.config/ranger

    # symlinks
    ln -fs $APP_PATH/rifle.conf ~/.config/ranger/rifle.conf
    ln -fs $APP_PATH/commands.py ~/.config/ranger/commands.py
    ln -fs $APP_PATH/rc.conf ~/.config/ranger/rc.conf
    ln -fs $APP_PATH/scope.sh ~/.config/ranger/scope.sh

    # clifm
    cd /tmp
    sudo apt install -y libcap-dev libacl1-dev libreadline-dev libmagic-dev udevil vlock archivemount
    [ -e clifm ] && rm -rf /tmp/clifm
    git clone https://github.com/leo-arch/clifm.git
    cd clifm
    export CPPFLAGS="$CPPFLAGS -D_ICONS_IN_TERMINAL"
    make -j8 && sudo make install

    # advcpmv
    cd /tmp
    [ -e advcpmv ] && rm -rf /tmp/advcpmv
    curl https://raw.githubusercontent.com/jarun/advcpmv/master/install.sh --create-dirs -o ./advcpmv/install.sh && (cd advcpmv && sh install.sh)
    sudo mv ./advcpmv/advcp /usr/local/bin/
    sudo mv ./advcpmv/advmv /usr/local/bin/
    pv $APP_PATH/clifmrc > ~/.config/clifm/profiles/default/clifmrc
    pv $APP_PATH/default-256.clifm > ~/.config/clifm/colors/default-256.clifm

    break
  elif [[ $response =~ ^(n|N)=$ ]]
  then
    break
  else
    echo " What? \"$resp\" is not a correct answer. Try y+Enter."
  fi
done
