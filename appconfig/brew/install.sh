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
    [[ -t 0 ]] && { read -t 10 -n 2 -p $'\e[1;32mInstall homebrew tools? [y/n] (default: '"$default"$')\e[0m\n' resp || resp=$default ; }
  fi
  response=`echo $resp | sed -r 's/(.*)$/\1=/'`

  if [[ $response =~ ^(y|Y)=$ ]]
  then

    # Brew
    case $(< ~/.bashrc 2>/dev/null) in
      *".linuxbrew"*)
        ;;
      *)
        toilet "Setting up brew"
        NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        (echo; echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"') >> ~/.bashrc
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
        ;;
    esac

    # exceed files limit
    ulimit -n2048

    # swiss knife
    until source $HOME/.bashrc && brew update && brew upgrade
    do
      echo Connection disrupted, retrying in 10 seconds...
      sleep 10
    done
    brew install -q grc fzy genact bat ripgrep miller ctop btop eza fd dust aria2
    brew cleanup --prune=all

    # configs
    mkdir -p ~/.config/gitui ~/.config/btop ~/.config/bat
    cp "$APP_PATH/key_bindings.ron" ~/.config/gitui/key_bindings.ron
    cp "$APP_PATH/btop.conf" ~/.config/btop/btop.conf
    cp "$APP_PATH/config" ~/.config/bat/config

    break
  elif [[ $response =~ ^(n|N)=$ ]]
  then
    break
  else
    echo " What? \"$resp\" is not a correct answer. Try y+Enter."
  fi
done
