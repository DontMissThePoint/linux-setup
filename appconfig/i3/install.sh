#!/bin/bash

set -e

trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
trap 'echo "$0: \"${last_command}\" command failed with exit code $?"' ERR

# get the path to this script
APP_PATH=`dirname "$0"`
APP_PATH=`( cd "$APP_PATH" && pwd )`

unattended=0
for param in "$@"
do
  echo $param
  if [ $param="--unattended" ]; then
    echo "installing in unattended mode"
    unattended=1
    subinstall_params="--unattended"
  fi
done

var1="18.04"
var2=`lsb_release -r | awk '{ print $2 }'`
[ "$var2" = "$var1" ] && export BEAVER=1

default=y
while true; do
  if [[ "$unattended" == "1" ]]
  then
    resp=$default
  else
    [[ -t 0 ]] && { read -t 10 -n 2 -p $'\e[1;32mInstall i3? [y/n] (default: '"$default"$')\e[0m\n' resp || resp=$default ; }
  fi
  response=`echo $resp | sed -r 's/(.*)$/\1=/'`

  if [[ $response =~ ^(y|Y)=$ ]]
  then

    sudo apt-get -y install libxcb1-dev libxcb-keysyms1-dev libpango1.0-dev libxcb-util0-dev libxcb-icccm4-dev libyajl-dev libstartup-notification0-dev libxcb-randr0-dev libev-dev libxcb-cursor-dev libxcb-xinerama0-dev libxcb-xkb-dev libxkbcommon-dev libxkbcommon-x11-dev autoconf libxcb-xrm0 libxcb-xrm-dev automake libxcb-shape0-dev dunst libkeybinder-3.0-0

    if [ -n "$beaver" ]; then
      sudo apt-get -y install python-keybinder gir1.2-keybinder
    fi

    # required for i3-layout-manager
    sudo apt-get -y install jq rofi xdotool x11-xserver-utils indent libanyevent-i3-perl

    if [ "$unattended" == "0" ] && [ -z $travis ]; # if running interactively
    then
      # install graphical x11 graphical backend with lightdm loading screen
      echo ""
      echo "-----------------------------------------------------------------"
      echo "installing lightdm login manager. it might require manual action."
      echo "-----------------------------------------------------------------"
      echo "if so, please select \"lightdm\", after hitting enter"
      echo ""
      echo "waiting for enter..."
      echo ""
      read
    fi

    sudo apt-get -y install lightdm

    # compile i3 dependency which is not present in the repo
    sudo apt-get -y install libtool xutils-dev

    # unlink
    brew unlink pkg-config meson

    cd /tmp
    [ -e xcb-util-xrm ] && rm -rf /tmp/xcb-util-xrm
    git clone https://github.com/airblader/xcb-util-xrm
    cd xcb-util-xrm
    git submodule update --init
    ./autogen.sh --prefix=/usr
    make -j8
    sudo make install

    # install light for display backlight control
    # compile light
    sudo apt-get -y install help2man

    cd $APP_PATH/../../submodules/light/
    ./autogen.sh
    ./configure && make
    sudo make install
    # set the minimal backlight value to 5%
    light -n 5
    # clean up after the compilation
    make clean
    git clean -fd

    # compile i3
    sudo pip3 install meson
    cd $APP_PATH/../../submodules/i3/

    # build from sources
    rm -fr /tmp/build && mkdir /tmp/build
    cd /tmp/build
    git clone https://www.github.com/airblader/i3 i3-gaps
    cd i3-gaps
    git checkout gaps && git pull
    sudo apt install meson asciidoc
    meson -Ddocs=true -Dmans=true ../build
    meson compile -C ../build
    sudo meson install -C ../build

    # clean after myself
    git reset --hard
    git clean -fd

    # compile i3 blocks
    cd $APP_PATH/../../submodules/i3blocks/
    ./autogen.sh
    ./configure
    make
    sudo make install

    # clean after myself
    git reset --hard
    git clean -fd

    # for cpu usage in i3blocks
    sudo apt-get -y install sysstat

    # for brightness and volume control
    sudo apt-get -y install xbacklight alsa-utils pulseaudio feh arandr

    arch=$( uname -i )
    if [ "$arch" != "aarch64" ]; then
      sudo apt-get -y install acpi
    fi

    # for making gtk look better
    sudo apt-get -y install lxappearance gtk-chtheme

    # indicator-sound-switcher
    sudo apt-get -y install libappindicator3-dev gir1.2-keybinder-3.0
    cd $APP_PATH/../../submodules/indicator-sound-switcher
    sudo python3 setup.py install

    # dunst
    mkdir -p ~/.config/dunst
    cp $APP_PATH/dunstrc ~/.config/dunst/dunstrc

    # symlink settings folder
    if [ ! -e ~/.i3 ]; then
      ln -sf $APP_PATH/doti3 ~/.i3
    fi

    # copy i3 config file
    cp $APP_PATH/doti3/config_git ~/.i3/config
    cp $APP_PATH/doti3/i3blocks.conf_git ~/.i3/i3blocks.conf
    cp $APP_PATH/i3blocks/wifi_git $APP_PATH/i3blocks/wifi
    cp $APP_PATH/i3blocks/battery_git $APP_PATH/i3blocks/battery

    # copy fonts
    # fontawesome 4.7
    mkdir -p ~/.fonts
    cp $APP_PATH/fonts/* ~/.fonts/

    # link fonts.conf file
    mkdir -p ~/.config/fontconfig
    ln -sf $APP_PATH/fonts.conf ~/.config/fontconfig/fonts.conf

    # link layouts
    mkdir -p ~/.config/i3-layout-manager/layouts
    ln -sf $APP_PATH/layouts/* ~/.config/i3-layout-manager/layouts

    # install useful gui utils
    sudo apt-get -y install thunar rofi compton systemd

    $APP_PATH/make_launchers.sh $APP_PATH/../../scripts

    # disable nautilus
    gsettings set org.gnome.desktop.background show-desktop-icons false

    # install xkb layout state
    cd $APP_PATH/../../submodules/xkblayout-state/
    make
    sudo ln -sf $APP_PATH/../../submodules/xkblayout-state/xkblayout-state /usr/bin/xkblayout-state

    # required for i3lock-color
    sudo apt remove -y i3lock

    sudo apt install -y libpam0g-dev libcairo2-dev libfontconfig1-dev libxcb-composite0-dev libev-dev libx11-xcb-dev libxcb-xkb-dev libxcb-xinerama0-dev libxcb-randr0-dev libxcb-image0-dev libxcb-util-dev libxcb-xrm-dev libxkbcommon-dev libxkbcommon-x11-dev libjpeg-dev

    # compile from sources
    cd /tmp
    [ -e i3lock-color ] && rm -rf i3lock-color
    git clone https://github.com/Raymo111/i3lock-color.git
    cd i3lock-color
    ./install-i3lock-color.sh

    # lockscreen with effects!
    wget -c https://raw.githubusercontent.com/betterlockscreen/betterlockscreen/main/install.sh -O - -q | sudo bash -s system latest true
    mkdir -p ~/.config/betterlockscreen/
    cp $APP_PATH/betterlockscreenrc ~/.config/betterlockscreen/betterlockscreenrc
    cp $APP_PATH/custom-pre.sh ~/.config/betterlockscreen/custom-pre.sh

    # [ falcon_heavy.jpg, lightning.jpg ]
    betterlockscreen -u $APP_PATH/../../miscellaneous/wallpapers/valley.jpg

    # install prime-select (for switching gpus)
    # sudo apt-get -y install nvidia-prime

    # relink
    brew link pkg-config meson

    break
  elif [[ $response =~ ^(n|N)=$ ]]
  then
    break
  else
    echo " What? \"$resp\" is not a correct answer. Try y+Enter."
  fi

done
