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
    [[ -t 0 ]] && { read -t 10 -n 2 -p $'\e[1;32mInstall nixpkgs? [y/n] (default: '"$default"$')\e[0m\n' resp || resp=$default ; }
  fi
  response=`echo $resp | sed -r 's/(.*)$/\1=/'`

  if [[ $response =~ ^(y|Y)=$ ]]
  then

    # nix
    num=`cat ~/.profile | grep "nix-profile" | wc -l`
    if [ "$num" -lt "1" ]; then

      toilet "Setting up nix"
      bash <(curl -L https://nixos.org/nix/install) --no-daemon
      pv "$APP_PATH/../zsh/dotzshrc_template" > ~/.zshrc

    fi

    # packages
    nix-env -iA nixpkgs.xidlehook nixpkgs.vivaldi nixpkgs.vivaldi-ffmpeg-codecs nixpkgs.megasync nixpkgs.gnomeExtensions.mock-tray

    # uninstall
    # rm -rf /nix

    break
  elif [[ $response =~ ^(n|N)=$ ]]
  then
    break
  else
    echo " What? \"$resp\" is not a correct answer. Try y+Enter."
  fi
done
