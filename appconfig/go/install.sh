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

var=$(lsb_release -r | awk '{ print $2 }')
[ "$var" = "18.04" ] && export BEAVER=1
[ "$var" = "24.04" ] && export NOBLE=1

default=y
while true; do
    if [[ "$unattended" == "1" ]]; then
        resp=$default
    else
        [[ -t 0 ]] && { read -t 10 -n 2 -p $'\e[1;32mInstall go (nchat, ledger)? [y/n] (default: '"$default"$')\e[0m\n' resp || resp=$default; }
    fi
    response=$(echo "$resp" | sed -r 's/(.*)$/\1=/')

    if [[ $response =~ ^(y|Y)=$ ]]; then

        toilet Installing nchat -t --filter metal -f smmono12
        sudo apt install -y ccache cmake build-essential gperf help2man libreadline-dev libssl-dev libncurses-dev libncursesw5-dev ncurses-doc zlib1g-dev libsqlite3-dev libmagic-dev

        # go
        sudo apt-get remove -y --auto-remove golang-go
        sudo rm -rf /usr/local/go
        wget -c https://go.dev/dl/go1.25.5.linux-amd64.tar.gz -O - | sudo tar -xz -C /usr/local

        # nchat
        cd /tmp
        [ -e nchat ] && sudo rm -rf nchat
        git clone https://github.com/d99kris/nchat.git
        cd nchat && mkdir -p build && cd build && cmake ..
        make -s -j8
        sudo make install

        # colors : basic-color, default, espresso, solarized-dark-higher-contrast, tomorrow-night, zenburned
        # catppuccin-mocha, dracula, gruvbox-dark, tokyo-night, zenbones-dark
        mkdir -p ~/.config/nchat
        cp -f "$(dirname "$(which nchat)")"/../share/nchat/themes/solarized-dark-higher-contrast/* ~/.config/nchat/

        # ledger
        echo "Setup go pakages..."
        go install github.com/howeyc/ledger/ledger@latest

        # nerdlog
        go install github.com/dimonomid/nerdlog/cmd/nerdlog@master

        # shfmt
        go install mvdan.cc/sh/v3/cmd/shfmt@latest

        # mpd-mpris
        go install github.com/natsukagami/mpd-mpris/cmd/mpd-mpris@latest

        # messages
        UGREEN='\033[4;32m'
        NC='\033[0m' # No Color
        echo "nchat --setup to get started."

        break
    elif [[ $response =~ ^(n|N)=$ ]]; then
        break
    else
        echo " What? \"$resp\" is not a correct answer. Try y+Enter."
    fi
done
