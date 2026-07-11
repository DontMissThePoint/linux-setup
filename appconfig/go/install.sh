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
        [[ -t 0 ]] && { read -t 10 -n 2 -p $'\e[1;32mInstall go (pidgin nchat, ledger)? [y/n] (default: '"$default"$')\e[0m\n' resp || resp=$default; }
    fi
    response=$(echo "$resp" | sed -r 's/(.*)$/\1=/')

    if [[ $response =~ ^(y|Y)=$ ]]; then

        toilet Installing nchat -t --filter metal -f smmono12
        sudo apt install -y ccache cmake build-essential gperf help2man libreadline-dev libssl-dev libncurses-dev libncursesw5-dev ncurses-doc zlib1g-dev libsqlite3-dev libgdk-pixbuf2.0-dev libpurple-dev libopusfile-dev libmagic-dev libgdk-pixbuf-2.0-0 libopusfile0 pidgin finch irssi irssi-scripts pidgin-dev
        brew unlink pkg-config libtool

        # go
        sudo apt-get remove -y --auto-remove golang-go
        sudo rm -rf /usr/local/go
        wget -c https://go.dev/dl/go1.25.5.linux-amd64.tar.gz -O - | sudo tar -xz -C /usr/local

        # whatsmeow
        cd /tmp
        [ -e purple-whatsmeow ] && sudo rm -rf purple-whatsmeow
        git clone --recurse-submodules https://github.com/hoehermann/purple-gowhatsapp.git purple-whatsmeow
        cmake -S purple-whatsmeow -B build
        cmake --build build
        sudo cmake --install build --strip
        cd build && sudo cpack
        sudo dpkg -i *.deb

        # paste-image
        cd /tmp
        [ -e pidgin-paste-image ] && sudo rm -rf pidgin-paste-image
        git clone https://github.com/EionRobb/pidgin-paste-image
        cd pidgin-paste-image
        make -s -j8
        sudo make install

        # login
        UGREEN='\033[4;32m'
        NC='\033[0m' # No Color
        echo "Login at: 256XXXXXXXXX@s.whatsapp.net"

        # config
        pv "$APP_PATH/gntrc" >~/.gntrc

        # ledger
        echo "Setup go pakages..."
        go install github.com/howeyc/ledger/ledger@latest

        # nerdlog
        go install github.com/dimonomid/nerdlog/cmd/nerdlog@master

        # shfmt
        go install mvdan.cc/sh/v3/cmd/shfmt@latest

        # mpd-mpris
        go install github.com/natsukagami/mpd-mpris/cmd/mpd-mpris@latest

        # nchat
        toilet Settingup nchat -t -f future

        cd /tmp
        [ -e nchat ] && sudo rm -rf nchat
        git clone https://github.com/d99kris/nchat
        cd nchat
        ./make.sh deps
        ./make.sh build && ./make.sh install

        # messages
        echo "nchat --setup to get started."
        brew link pkg-config libtool

        break
    elif [[ $response =~ ^(n|N)=$ ]]; then
        break
    else
        echo " What? \"$resp\" is not a correct answer. Try y+Enter."
    fi
done
