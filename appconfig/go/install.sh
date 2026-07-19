#!/bin/bash

set -e

trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
trap 'echo "$0: \"${last_command}\" command failed with exit code $?"' ERR

# get the path to this script
APP_PATH=$(dirname "$0")
APP_PATH=$( (cd "$APP_PATH" && pwd))
GO_VERSION=$(curl -fsSL 'https://go.dev/VERSION?m=text' | head -n1)

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
        [[ -t 0 ]] && { read -t 10 -n 2 -p $'\e[1;32mInstall go (nchat, ledger)? [y/n] (default: '"$default"$')\e[0m\n' resp || resp=$default; }
    fi
    response=$(echo "$resp" | sed -r 's/(.*)$/\1=/')

    if [[ $response =~ ^(y|Y)=$ ]]; then

        toilet Installing go -t --filter metal -f smmono12

        sudo apt install -y ccache cmake build-essential gperf help2man libreadline-dev libssl-dev libncurses-dev libncursesw5-dev ncurses-doc zlib1g-dev libsqlite3-dev libmagic-dev
        /home/linuxbrew/.linuxbrew/bin/brew unlink pkg-config libtool

        # go
        sudo apt-get remove -y --auto-remove golang-go
        sudo rm -rf /usr/local/go
        wget -c "https://go.dev/dl/${GO_VERSION}.linux-amd64.tar.gz" -O - | sudo tar -xz -C /usr/local
        export PATH=/usr/local/go/bin:$PATH

        # nchat
        toilet Settingup nchat -t -f future

        cd /tmp
        [ -e nchat ] && sudo rm -rf nchat
        git clone https://github.com/d99kris/nchat
        cd nchat
        mkdir -p build && cd build && cmake .. && make -j"$(nproc)" -s
        sudo make install

        # messages
        echo "nchat --setup to get started."

        # jq
        cd /tmp
        [ -e jq ] && rm -rf jq
        git clone https://github.com/jqlang/jq
        cd jq
        git submodule update --init # if building from git to get oniguruma
        autoreconf -i               # if building from git
        ./configure --with-oniguruma=builtin
        make clean # if upgrading from a version previously built from source
        make -j"$(nproc)"
        make check
        sudo make install

        # zap
        #toilet Settingup zap zap -t -f future

        #cd /tmp
        #sudo /home/linuxbrew/.linuxbrew/bin/dra download \
            #	--select '*amd64.deb' -i rafatosta/zapzap

        # ledger
        go install github.com/howeyc/ledger/ledger@latest

        # pomo
        go install github.com/Bahaaio/pomo@latest

        # nerdlog
        go install github.com/dimonomid/nerdlog/cmd/nerdlog@master

        # shfmt
        go install mvdan.cc/sh/v3/cmd/shfmt@latest

        # gopls
        go install -v golang.org/x/tools/gopls@latest

        # mpd-mpris
        go install github.com/natsukagami/mpd-mpris/cmd/mpd-mpris@latest

        # config
        mkdir -p ~/.config/pomo
        pv "$APP_PATH/pomo.yaml" >~/.config/pomo/pomo.yaml

        # link
        /home/linuxbrew/.linuxbrew/bin/brew link pkg-config libtool

        break
    elif [[ $response =~ ^(n|N)=$ ]]; then
        break
    else
        echo " What? \"$resp\" is not a correct answer. Try y+Enter."
    fi
done
