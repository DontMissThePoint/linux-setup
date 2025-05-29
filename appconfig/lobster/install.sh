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
  echo $param
  if [ $param="--unattended" ]; then
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
    [[ -t 0 ]] && { read -t 10 -n 2 -p $'\e[1;32mInstall lobster (stream all movies)? [y/n] (default: '"$default"$')\e[0m\n' resp || resp=$default; }
  fi
  response=$(echo $resp | sed -r 's/(.*)$/\1=/')

  if [[ $response =~ ^(y|Y)=$ ]]; then

    toilet Installing lobster -t --filter metal -f smmono12

    # ueberzug
    cd /tmp
    [ -e ueberzugpp ] && rm -rf ueberzugpp
    sudo apt install -y libssl-dev libvips-dev libsixel-dev libchafa-dev libtbb-dev libxcb-res0-dev
    git clone https://github.com/jstkdng/ueberzugpp.git
    cd ueberzugpp
    mkdir build && cd build
    cmake -DCMAKE_BUILD_TYPE=Release -DENABLE_OPENCV=OFF ..
    cmake --build .
    sudo cp -f ueberzug /usr/local/bin/ueberzug
    sudo ln -sf /usr/local/bin/ueberzug /usr/bin/ueberzugpp

    # lobster
    curl -sL github.com/justchokingaround/lobster/raw/main/lobster.sh -o "$(brew --prefix)"/bin/lobster &&
      chmod +x "$(brew --prefix)"/bin/lobster
    touch $HOME/.local/share/lobster/lobster_history.txt

    # yt-x
    toilet Settingup yt-x -t -f future
    curl -sL "https://raw.githubusercontent.com/Benexl/yt-x/refs/heads/master/yt-x" -o ~/.local/bin/yt-x && chmod +x ~/.local/bin/yt-x

    # libg-fzf
    echo "Adding Library Genesis.."
    sudo curl -sL https://raw.githubusercontent.com/mrishu/libg-fzf/main/libg -o /usr/local/bin/libg &&
      sudo chmod +x /usr/local/bin/libg

    # config
    echo "Configuring..."
    mkdir -p ~/.config/lobster ~/.config/libg
    pv "$APP_PATH/lobster_config.txt" >~/.config/lobster/lobster_config.txt
    pv "$APP_PATH/libg.sh" >~/.config/libg/libg.sh

    # bt client
    the_ppa=qbittorrent-team/qbittorrent-stable
    if ! grep -q "^deb .*$the_ppa" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
      sudo apt-add-repository ppa:qbittorrent-team/qbittorrent-stable
      sudo apt update
      sudo apt install -y qbittorrent
    fi

    break
  elif [[ $response =~ ^(n|N)=$ ]]; then
    break
  else
    echo " What? \"$resp\" is not a correct answer. Try y+Enter."
  fi
done
