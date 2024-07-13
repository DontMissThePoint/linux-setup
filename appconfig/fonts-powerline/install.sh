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
    [[ -t 0 ]] && { read -t 10 -n 2 -p $'\e[1;32mInstall powerline fonts? [y/n] (default: '"$default"$')\e[0m\n' resp || resp=$default ; }
  fi
  response=`echo $resp | sed -r 's/(.*)$/\1=/'`

  if [[ $response =~ ^(y|Y)=$ ]]
  then

    toilet Setting up powerline fonts

    cd $APP_PATH/../../submodules/fonts
    cp -fr $APP_PATH/fonts ./fonts.orig

    # apply our patch to change the font installation dir
    # git apply $APP_PATH/patch.patch

    ./install.sh
    rm -fr ./fonts.orig

    # make Terminus work
    mkdir -p ~/.config/fontconfig/conf.d
    cp fontconfig/50-enable-terminess-powerline.conf ~/.config/fontconfig/conf.d

    # Look and feel
    the_ppa=papirus/papirus
    if ! grep -q "^deb .*$the_ppa" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
        sudo add-apt-repository -y ppa:papirus/papirus
        sudo apt update
        sudo apt install -y papirus-icon-theme  # Papirus, Papirus-Dark, and Papirus-Light
    fi
    sudo apt install -y fonts-inter-variable fonts-symbola ttf-bitstream-vera dconf-editor arc-theme qt5-style-kvantum qt5-style-kvantum-themes

    # NF
    toilet Installing Nerd Fonts
    curl -fsSL https://raw.githubusercontent.com/getnf/getnf/main/install.sh | bash -s -- --branch=release-0.1
    getnf -i "JetBrainsMono Meslo iA-Writer NerdFontsSymbolsOnly UbuntuMono"
    getnf -U

    # emoji
    sh -c "$(wget -O- https://raw.githubusercontent.com/edicsonabel/emojix/master/install.sh 2>/dev/null)"
    wget -c -P "$APP_PATH" https://github.com/13rac1/twemoji-color-font/releases/download/v14.0.2/TwitterColorEmoji-SVGinOT-Linux-14.0.2.tar.gz
    cd $APP_PATH
    tar zxf TwitterColorEmoji-SVGinOT-Linux-14.0.2.tar.gz
    cd TwitterColorEmoji-SVGinOT-Linux-14.0.2
    ./install.sh
    rm -fr $APP_PATH/TwitterColorEmoji-*

    # icons-in-terminal
    cd /tmp
    [ -e icons-in-terminal ] && rm -rf /tmp/icons-in-terminal
    git clone https://github.com/sebastiencs/icons-in-terminal.git
    cd icons-in-terminal
    ./install.sh
    pv $APP_PATH/30-icons.conf > ~/.config/fontconfig/conf.d/30-icons.conf
    find ~/.config/fontconfig/conf.d ! -name '30-icons.conf' ! -name '50-enable-terminess-powerline.conf' -type f -exec rm -f {} +

    # Test with:
    # fc-match -s serif
    # fc-match -s sans-serif
    # fc-match -s monospace
    fc-cache -vf

    # config
    echo "Configuring..."
    mkdir -p ~/.config/environment.d ~/.config/Kvantum
    printf 'QT_STYLE_OVERRIDE=kvantum' > ~/.config/environment.d/qt.conf
    pv $APP_PATH/kvantum.kvconfig > ~/.config/Kvantum/kvantum.kvconfig

    # activate
    gsettings set org.gnome.desktop.interface gtk-theme 'Arc-Darker'
    gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Dark'
    gsettings set org.gnome.desktop.interface font-name 'Inter Variable 11'
    gsettings set org.gnome.desktop.interface document-font-name 'Inter Variable 11'
    gsettings set org.gnome.desktop.interface monospace-font-name 'JetBrainsMono Nerd Font Mono 11'
    sudo gtk-update-icon-cache -f -t /usr/share/icons/Papirus-Dark
    xdg-desktop-menu forceupdate

    # undo the patch
    # git reset --hard

    break
  elif [[ $response =~ ^(n|N)=$ ]]
  then
    break
  else
    echo " What? \"$resp\" is not a correct answer. Try y+Enter."
  fi
done
