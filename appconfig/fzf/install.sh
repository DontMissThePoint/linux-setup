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
    [[ -t 0 ]] && { read -t 5 -n 2 -p $'\e[1;32mInstall fzf? [y/n] (default: '"$default"$')\e[0m\n' resp || resp=$default ; }
  fi
  response=`echo $resp | sed -r 's/(.*)$/\1=/'`

  if [[ $response =~ ^(y|Y)=$ ]]
  then

    cd $APP_PATH/../../submodules/fzf/
    ./install --no-key-bindings --no-completion --no-update-rc --no-bash --no-zsh --no-fish

    mkdir -p ~/.config/fzf 2> /dev/null

    ln -fs $APP_PATH/config/fzf.bash ~/.config/fzf/fzf.bash
    ln -fs $APP_PATH/config/fzf.zsh ~/.config/fzf/fzf.zsh

    # fnf's not fzy
    toilet Settingup fnf -t -f future

    cd /tmp
    [ -e fnf ] && rm -rf fnf
    git clone https://github.com/leo-arch/fnf
    cd fnf
    make -j8
    sudo make install

    # preview
    echo "Adding fzf previews.."
    sudo cp -f $APP_PATH/preview /usr/local/bin/preview
    sudo chmod a+x /usr/local/bin/preview

    break
  elif [[ $response =~ ^(n|N)=$ ]]
  then
    break
  else
    echo " What? \"$resp\" is not a correct answer. Try y+Enter."
  fi
done
