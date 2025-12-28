#!/bin/bash

set -e

trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
trap 'echo "$0: \"${last_command}\" command failed with exit code $?"' ERR

# get the path to this script
APP_PATH=$(dirname "$0")
APP_PATH=$( (cd "$APP_PATH" && pwd))
CONFIG="$HOME/.config/nvim"
DATA="$HOME/.local/share/nvim"

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
        [[ -t 0 ]] && { read -t 10 -n 2 -p $'\e[1;32mInstall neovim? [y/n] (default: '"$default"$')\e[0m\n' resp || resp=$default; }
    fi
    response=$(echo "$resp" | sed -r 's/(.*)$/\1=/')

    if [[ $response =~ ^(y|Y)=$ ]]; then

        toilet Installing neovim -t --filter metal -f smmono12

        sudo apt-get -y remove neovim* || echo ""

        sudo apt-get -y install ninja-build gettext protobuf-compiler cmake unzip curl rustup

        # compile neovim from sources
        rm -fr /tmp/nvim && mkdir /tmp/nvim && cd /tmp/nvim
        git clone https://github.com/neovim/neovim.git
        cd neovim
        cd /tmp/nvim/neovim
        make -j8 CMAKE_BUILD_TYPE=RelWithDebInfo \
            CMAKE_INSTALL_PREFIX=/usr/bin/nvim

        cd build && cpack -G DEB && sudo dpkg -i /tmp/nvim/neovim/build/nvim-linux-x86_64.deb

        # nvim
        /usr/bin/python3 -m pip install --break-system-packages --ignore-installed wheel neovim neovim-remote
        rm -rf "$DATA" "$CONFIG"

        echo "Configuring lsp..."
        rustup default stable
        rustup update

        # cargo
        cargo install cargo-update cargo-cache shellharden
        # rustup self uninstall

        # Nvchad
        git clone https://github.com/NvChad/starter "$CONFIG"
        cp -fr "$APP_PATH"/starter/lua/* "$CONFIG"/lua && nvim +MasonUpdate -c "TSInstall all"
        rm -fr "$CONFIG"/.git

        # smartGit
        . "$APP_PATH"/smartgit.sh

        break
    elif [[ $response =~ ^(n|N)=$ ]]; then
        break
    else
        echo " What? \"$resp\" is not a correct answer. Try y+Enter."
    fi
done
