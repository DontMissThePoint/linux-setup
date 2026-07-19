#!/bin/bash

set -e

trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
trap 'echo "$0: \"${last_command}\" command failed with exit code $?"' ERR

# get the path to this script
APP_PATH=$(dirname "$0")
APP_PATH=$( (cd "$APP_PATH" && pwd))
FONTS_PATH="$HOME"/.local/share/fonts

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
        [[ -t 0 ]] && { read -t 10 -n 2 -p $'\e[1;32mInstall powerline fonts? [y/n] (default: '"$default"$')\e[0m\n' resp || resp=$default; }
    fi
    response=$(echo "$resp" | sed -r 's/(.*)$/\1=/')

    if [[ $response =~ ^(y|Y)=$ ]]; then

        toilet Setting up powerline fonts -t -f future

        sudo apt install -y fonts-symbola unifont fonts-font-awesome fonts-noto-color-emoji ttf-bitstream-vera

        cd "$APP_PATH"/../../submodules/fonts
        cp -fr "$APP_PATH"/fonts ./fonts.orig

        # apply our patch to change the font installation dir
        # git apply $APP_PATH/patch.patch

        ./install.sh
        rm -fr ./fonts.orig
        . ~/.profile

        # make Terminus work
        mkdir -p ~/.config/fontconfig/conf.d
        cp fontconfig/50-enable-terminess-powerline.conf ~/.config/fontconfig/conf.d

        # Nerd fonts
        toilet Setting up Nerd Fonts -t -f future

        # getnf
        curl -fsSL https://raw.githubusercontent.com/getnf/getnf/main/install.sh | bash
        getnf -i "JetBrainsMono Terminus FiraMono Meslo Monofur Hermit IBMPlexMono iA-Writer \
          NerdFontsSymbolsOnly UbuntuMono ProFont"
        getnf -U 2>/dev/null || rm -fr ~/Downloads/getnf

        # tx
        mkdir -p "$FONTS_PATH"/{TTF,OTF}
        mv "$FONTS_PATH"/*.otf "$FONTS_PATH"/OTF || mv "$FONTS_PATH"/*.ttf "$FONTS_PATH"/TTF || \
            echo "Configuring..."

        # terminus
        sed -i -e 's/terminess powerline/Terminess Nerd Font/g' \
            ~/.config/fontconfig/conf.d/50-enable-terminess-powerline.conf

        # emoji
        pv "$APP_PATH"/10-emoji.conf >~/.config/fontconfig/conf.d/10-emoji.conf

        # cursor
        gsettings set org.cinnamon.desktop.interface scaling-factor 1
        gsettings set org.cinnamon.desktop.interface text-scaling-factor 1
        gsettings set org.cinnamon.desktop.interface cursor-size 24

        # cache
        fc-cache -vf

        break
    elif [[ $response =~ ^(n|N)=$ ]]; then
        break
    else
        echo " What? \"$resp\" is not a correct answer. Try y+Enter."
    fi
done
