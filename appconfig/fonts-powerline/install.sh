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

        # Look and feel
        the_ppa=papirus/papirus
        if ! grep -q "^deb .*$the_ppa" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
            sudo add-apt-repository -y ppa:papirus/papirus
            sudo apt update
            sudo apt install -y papirus-icon-theme
        fi
        sudo apt install -y fonts-inter-variable fonts-symbola unifont fonts-font-awesome fonts-noto-color-emoji ttf-bitstream-vera dconf-editor arc-theme qt5-style-kvantum qt5-style-kvantum-themes
        papirus-folders -t Papirus-Dark -C yaru

        # Nerd fonts
        toilet Setting up Nerd Fonts -t -f future

        # getnf
        curl -fsSL https://raw.githubusercontent.com/getnf/getnf/main/install.sh | bash -s -- --tag=v0.1.0
        getnf -i "JetBrainsMono Terminus FiraMono Meslo Monofur Hermit IBMPlexMono iA-Writer \
          NerdFontsSymbolsOnly UbuntuMono ProFont"
        getnf -U 2>/dev/null || rm -fr ~/Downloads/getnf

        # Monaspace
        cd /tmp
        [ -e monaspace ] && rm -rf /tmp/monaspace
        git clone https://github.com/githubnext/monaspace
        cd monaspace
        cp -r fonts/{NerdFonts,Frozen\ Fonts}/* "$FONTS_PATH"

        # terminus
        sed -i -e 's/terminess powerline/Terminess Nerd Font/g' \
            ~/.config/fontconfig/conf.d/50-enable-terminess-powerline.conf

        # emoji
        pv "$APP_PATH"/10-emoji.conf >~/.config/fontconfig/conf.d/10-emoji.conf

        # qt6ct
        sudo apt install -y qt6-base-dev qt6-base-dev-tools qt6-base-private-dev qt6-tools-dev qt6-tools-dev-tools linguist-qt6

        cd /tmp
        [ -e qt6ct ] && rm -rf qt6ct
        git clone https://github.com/trialuser02/qt6ct
        cd qt6ct
        cmake -DCMAKE_INSTALL_PREFIX=/usr/local/bin
        make -j8
        sudo make install

        mkdir -p ~/.config/qt{5,6}ct
        pv "$APP_PATH"/qt5ct.conf >~/.config/qt5ct/qt5ct.conf
        pv "$APP_PATH"/qt6ct.conf >~/.config/qt6ct/qt6ct.conf

        # config
        mkdir -p "$FONTS_PATH"/{TTF,OTF}
        mkdir -p ~/.config/environment.d ~/.config/Kvantum
        mv "$FONTS_PATH"/*.otf "$FONTS_PATH"/OTF || mv "$FONTS_PATH"/*.ttf "$FONTS_PATH"/TTF || \
            echo "Configuring..."
        printf 'QT_STYLE_OVERRIDE=kvantum' >~/.config/environment.d/qt.conf
        pv "$APP_PATH"/kvantum.kvconfig >~/.config/Kvantum/kvantum.kvconfig

        # cursor
        cd /tmp
        [ -e Afterglow-Cursors-Recolored ] && rm -rf /tmp/Afterglow-Cursors-Recolored
        git clone https://github.com/TeddyBearKilla/Afterglow-Cursors-Recolored
        cd Afterglow-Cursors-Recolored/colors/Gruvbox/Black
        sudo ./install.sh
        gsettings set org.gnome.desktop.interface cursor-theme 'Afterglow-Recolored-Gruvbox-Black'
        gsettings set org.gnome.desktop.interface cursor-size 32

        # animations
        gsettings set org.gnome.desktop.interface enable-animations false

        # interface
        gsettings set org.gnome.desktop.interface gtk-theme 'Arc-Darker'
        gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Dark'
        gsettings set org.gnome.desktop.interface font-name 'Ubuntu Nerd Font Propo 9'
        gsettings set org.gnome.desktop.interface document-font-name 'Inter Variable 9'
        gsettings set org.gnome.desktop.interface monospace-font-name 'Hurmit Nerd Font Mono 9'
        gsettings set org.gnome.desktop.wm.preferences titlebar-font 'Cantarell Bold 9'
        gsettings set org.gnome.desktop.wm.preferences titlebar-uses-system-font false
        gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
        gsettings set org.gnome.desktop.wm.preferences theme 'Arc-Darker'
        gsettings set org.gnome.shell.ubuntu color-scheme 'prefer-dark'

        # cursor
        gsettings set org.gnome.desktop.interface locate-pointer true
        gsettings set org.gnome.desktop.interface cursor-size 32

        # extensions
        sudo mkdir -p /usr/share/themes/Arc-Darker/gnome-shell
        sudo cp -f "$APP_PATH"/gnome-shell.css /usr/share/themes/Arc-Darker/gnome-shell/gnome-shell.css
        gsettings set org.gnome.shell.extensions.user-theme name 'Arc-Darker'

        # cache
        sudo gtk-update-icon-cache -f -t /usr/share/icons/Papirus-Dark
        xdg-desktop-menu forceupdate
        fc-cache -vf

        # undo the patch
        # git reset --hard

        break
    elif [[ $response =~ ^(n|N)=$ ]]; then
        break
    else
        echo " What? \"$resp\" is not a correct answer. Try y+Enter."
    fi
done
