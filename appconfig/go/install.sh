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
        [[ -t 0 ]] && { read -t 10 -n 2 -p $'\e[1;32mInstall go (pidgin, nchat)? [y/n] (default: '"$default"$')\e[0m\n' resp || resp=$default; }
    fi
    response=$(echo "$resp" | sed -r 's/(.*)$/\1=/')

    if [[ $response =~ ^(y|Y)=$ ]]; then

        toilet Installing nchat -t --filter metal -f smmono12
        sudo apt install -y ccache cmake build-essential gperf help2man libreadline-dev libssl-dev libncurses-dev libncursesw5-dev ncurses-doc zlib1g-dev libsqlite3-dev libmagic-dev golang

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

        # pidgin
        toilet Setting up go-whatsapp -t -f future
        sudo apt install -y finch pidgin pkg-config cmake make golang gcc libgdk-pixbuf2.0-dev libopusfile-dev libpurple-bin libpurple-dev

        # config
        mkdir -p ~/.purple/plugins

        # go
        sudo rm -rf /usr/local/go
        wget -c https://go.dev/dl/go1.24.3.linux-amd64.tar.gz -O - | sudo tar -xz -C /usr/local

        EXISTING_GO=$(cat ~/.profile 2>/dev/null | grep "go/bin" | wc -l)
        if [ "$EXISTING_GO" == "0" ]; then
            toilet Settingup go -t -f future
            (
                echo
                echo 'export PATH=$PATH:/usr/local/go/bin'
            ) >>~/.profile
        fi
        export PATH=$PATH:/usr/local/go/bin

        # ledger
        echo "Setup go pakages..."
        go install github.com/howeyc/ledger/ledger@latest
        sudo ln -sf ~/go/bin/ledger /usr/local/go/bin/ledger

        # nerdlog
        go install github.com/dimonomid/nerdlog/cmd/nerdlog@master
        sudo ln -sf ~/go/bin/nerdlog /usr/local/go/bin/nerdlog

        # shfmt
        go install mvdan.cc/sh/v3/cmd/shfmt@latest
        sudo ln -sf ~/go/bin/shfmt /usr/local/go/bin/shfmt

        # mpd-mpris
        go install github.com/natsukagami/mpd-mpris/cmd/mpd-mpris@latest
        sudo ln -sf ~/go/bin/mpd-mpris /usr/local/go/bin/mpd-mpris

        # compile from sources
        cd /tmp
        [ -e purple-gowhatsapp ] && rm -rf purple-gowhatsapp
        git clone https://github.com/hoehermann/purple-gowhatsapp.git
        cd purple-gowhatsapp
        git submodule update --init
        mkdir -p build && cd build
        cmake ..
        cmake --build .
        sudo make install/strip

        # whatsapp
        cmake -DPURPLE_DATA_DIR:PATH=~/.local/share -DPURPLE_PLUGIN_DIR:PATH=~/.purple/plugins ..

        # prefs
        UGREEN='\033[4;32m'
        NC='\033[0m' # No Color
        echo "nchat --setup to get started."
        echo -e "Pidgin: 2567XXXXXXXX${UGREEN}@s.whatsapp.net${NC}"

        break
    elif [[ $response =~ ^(n|N)=$ ]]; then
        break
    else
        echo " What? \"$resp\" is not a correct answer. Try y+Enter."
    fi
done
