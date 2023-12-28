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
    EXISTING_BREW=`cat ~/.profile 2> /dev/null | grep ".linuxbrew" | wc -l`
    if [ "$EXISTING_BREW" == "0" ]; then
      toilet Setting up brew
      NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
      (echo; echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"') >> ~/.profile
      eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    fi

    # swiss knife
    until brew update && brew upgrade
    do
      echo Links disrupted, retrying in 10 seconds...
      sleep 10
    done
    brew install -q grc starship fzy bat ripgrep miller ctop btop eza fd dust
    brew cleanup --prune=all

    # configs
    cp "$APP_PATH/key_bindings.ron" ~/.config/gitui/key_bindings.ron
    cp "$APP_PATH/btop.conf" ~/.config/btop/btop.conf

    # exceed files limit
    # ulimit -n2048

    # To relink, run:
    #brew unlink libxml2 && brew link libxml2

    # Cleanup
    brew cleanup --prune=all

    break
  elif [[ $response =~ ^(n|N)=$ ]]
  then
    break
  else
    echo " What? \"$resp\" is not a correct answer. Try y+Enter."
  fi
done
