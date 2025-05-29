#!/bin/bash

set -e

trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
trap 'echo "$0: \"${last_command}\" command failed with exit code $?"' ERR

# get the path to this script
APP_PATH=$(dirname "$0")
APP_PATH=$( (cd "$APP_PATH" && pwd))

unattended=0
subinstall_params=""
for param in "$@"; do
  echo "$param"
  if [ "$param=--unattended" ]; then
    echo "installing in unattended mode"
    unattended=1
    subinstall_params="--unattended"
  fi
done

default=y
while true; do
  if [[ "$unattended" == "1" ]]; then
    resp=$default
  else
    [[ -t 0 ]] && { read -t 10 -n 2 -p $'\e[1;32mInstall yt-dlp (youtube videos, gallery downloader)? [y/n] (default: '"$default"$')\e[0m\n' resp || resp=$default; }
  fi
  response=$(echo "$resp" | sed -r 's/(.*)$/\1=/')

  if [[ $response =~ ^(y|Y)=$ ]]; then

    toilet Installing yt-dlp -t --filter metal -f smmono12

    # opencv
    sudo apt install -y libopencv-dev python3-opencv intel-media-va-driver-non-free

    # gallery-dl
    pipx install yt-dlp gallery-dl

    # config
    echo "Configuring..."
    mkdir -p ~/.config/yt-dlp ~/.config/gallery-dl
    pv "$APP_PATH"/yt-dlp.conf >~/.config/yt-dlp/yt-dlp.conf
    pv "$APP_PATH"/config.json >~/.config/gallery-dl/config.json
    echo "Done."

    # yt-dlp
    mkdir -p ~/VirtualMachines/YoutubeDL-Material
    cd ~/VirtualMachines/YoutubeDL-Material
    curl -L https://github.com/Tzahi12345/YoutubeDL-Material/releases/latest/download/docker-compose.yml -o docker-compose.yml
    docker compose pull
    # docker compose up
    # connect http://localhost:8998/#/home

    # yt-x

    break
  elif [[ $response =~ ^(n|N)=$ ]]; then
    break
  else
    echo " What? \"$resp\" is not a correct answer. Try y+Enter."
  fi
done
