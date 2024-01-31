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

    cd $APP_PATH/../../submodules
    mv fonts fonts.orig
    git clone https://github.com/powerline/fonts.git

    # apply our patch to change the font installation dir
    # git apply $APP_PATH/patch.patch
    cd fonts
    cp -rf ../fonts.orig/* ./
    ./install.sh
    cd ..; rm -fr fonts; mv fonts.orig fonts

    # Look and feel
    the_ppa=papirus/papirus
    if ! grep -q "^deb .*$the_ppa" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
        sudo add-apt-repository -y ppa:papirus/papirus
        sudo apt update
        sudo apt install -y papirus-icon-theme  # Papirus, Papirus-Dark, and Papirus-Light
    fi
    sudo apt install -y fonts-symbola dconf-editor arc-theme qt5-style-kvantum qt5-style-kvantum-themes

    # emoji
    sh -c "$(wget -O- https://raw.githubusercontent.com/edicsonabel/emojix/master/install.sh 2>/dev/null)"

    # refresh
    fc-cache -vf

    # config
    mkdir -p ~/.config/environment.d ~/.config/Kvantum
    printf 'QT_STYLE_OVERRIDE=kvantum' > ~/.config/environment.d/qt.conf
    cp $APP_PATH/kvantum.kvconfig ~/.config/Kvantum/kvantum.kvconfig

    # activate
    gsettings set org.gnome.desktop.interface gtk-theme 'Arc-Darker'
    gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Dark'
    sudo gtk-update-icon-cache -f -t /usr/share/icons/Papirus-Dark && xdg-desktop-menu forceupdate

    # undo the patch
    # git reset --hard

    # fontforge
    toilet Installing fontforge

    cd /tmp
    sudo apt install -y libjpeg-dev libtiff5-dev libpng-dev libfreetype6-dev libgif-dev libgtk-3-dev libxml2-dev libpango1.0-dev libcairo2-dev libspiro-dev libwoff-dev python3-dev ninja-build cmake build-essential gettext
    [ -e fontforge ] && rm -rf fontforge
    git clone https://github.com/fontforge/fontforge.git
    cd fontforge
    mkdir build && cd build
    cmake -GNinja ..
    ninja
    sudo ninja install

    break
  elif [[ $response =~ ^(n|N)=$ ]]
  then
    break
  else
    echo " What? \"$resp\" is not a correct answer. Try y+Enter."
  fi
done
