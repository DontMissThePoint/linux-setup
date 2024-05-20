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
    [[ -t 0 ]] && { read -t 10 -n 2 -p $'\e[1;32mInstall homebrew? [y/n] (default: '"$default"$')\e[0m\n' resp || resp=$default ; }
  fi
  response=`echo $resp | sed -r 's/(.*)$/\1=/'`

  if [[ $response =~ ^(y|Y)=$ ]]
  then

    # Brew

    num=`cat ~/.bashrc | grep "linuxbrew" | wc -l`
    if [ "$num" -lt "1" ]; then

      toilet "Setting up brew"
      NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
      (echo; echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"') >> ~/.bashrc
      eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

    fi

    # exceed files limit
    ulimit -n2048

    # swiss knife
    until source $HOME/.bashrc && brew update && brew upgrade
    do
      echo Connection disrupted, retrying in 10 seconds...
      sleep 10
    done
    brew install grc fzf bat ripgrep miller ctop btop eza fd s-search dust aria2 glow
    brew cleanup --prune=all

    # configs
    echo "Configuring..."
    mkdir -p ~/.config/gitui ~/.config/btop ~/.config/bat ~/.aria2 ~/.config/aria2 ~/.config/glow ~/.config/s
    pv "$APP_PATH/key_bindings.ron" > ~/.config/gitui/key_bindings.ron
    pv "$APP_PATH/btop.conf" > ~/.config/btop/btop.conf
    pv "$APP_PATH/bat.config >" ~/.config/bat/config
    pv "$APP_PATH/s.config" > ~/.config/s/config
    pv "$APP_PATH/aria2.conf" > ~/.config/aria2/aria2.conf
    pv "$APP_PATH/glow.yml" > ~/.config/glow/glow.yml

    # update bt-trackers
    echo "Updating bt-trackers... "
    $GIT_PATH/linux-setup/scripts/aria2-trackers-update.sh

    break
  elif [[ $response =~ ^(n|N)=$ ]]
  then
    break
  else
    echo " What? \"$resp\" is not a correct answer. Try y+Enter."
  fi
done
