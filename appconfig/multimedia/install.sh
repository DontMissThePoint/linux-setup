#!/bin/bash

set -e

trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
trap 'echo "$0: \"${last_command}\" command failed with exit code $?"' ERR

# get the path to this script
APP_PATH=`dirname "$0"`
APP_PATH=`( cd "$APP_PATH" && pwd )`
CONFIG="$HOME/.config/mpv"

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

var=`lsb_release -r | awk '{ print $2 }'`
[ "$var" = "20.04" ] && export FOCAL=1
[ "$var" = "22.04" ] && export JAMMY=1

default=y
while true; do
  if [[ "$unattended" == "1" ]]
  then
    resp=$default
  else
    [[ -t 0 ]] && { read -t 10 -n 2 -p $'\e[1;32mInstall multimedia support (editors, players, ...)? [y/n] (default: '"$default"$')\e[0m\n' resp || resp=$default ; }
  fi
  response=`echo $resp | sed -r 's/(.*)$/\1=/'`

  if [[ $response =~ ^(y|Y)=$ ]]
  then

    toilet Installing MPV

    # jq
    cd /tmp
    [ -e jq ] && rm -rf jq
    git clone https://github.com/jqlang/jq
    cd jq
    git submodule update --init    # if building from git to get oniguruma
    autoreconf -i                  # if building from git
    ./configure --with-oniguruma=builtin
    make clean                     # if upgrading from a version previously built from source
    make -j8
    make check
    sudo make install

    # use in pdfpc to play videos
    sudo apt-get -y install gstreamer1.0-libav libxpresent1

    # for video, photo, audio, ..., viewing and editing
    sudo pip install subliminal ffsubsync
    sudo apt-get -y install ffmpeg gimp screenkey vlc audacity rawtherapee pavucontrol newsboat

    # newsboat
    cp -rf "$APP_PATH/newsboat" ~/.config/

    # mpv
    if [ -n "$FOCAL" ] || [ -n "$JAMMY" ]; then

      # Add the repository to apt sources
      if [ ! -e /etc/apt/sources.list.d/non-gnu-uvt.list ]; then
        sudo apt-get update
        sudo apt-get install -y ca-certificates curl gnupg apt-transport-https

        # GPG key
        sudo install -m 0755 -d /etc/apt/trusted.gpg.d
        curl -fsSL https://non-gnu.uvt.nl/debian/uvt_key.gpg | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/uvt_key.gpg
        sudo chmod a+r /etc/apt/trusted.gpg.d

        echo \
          "deb https://non-gnu.uvt.nl/debian $(lsb_release -sc) uvt" | \
          sudo tee /etc/apt/sources.list.d/non-gnu-uvt.list > /dev/null
        sudo apt-get update
        sudo apt install -y -t "o=UvT" mpv
      fi
      
    else
      sudo apt install -y mpv
    fi

    # xidel
    wget -c -P "$APP_PATH" https://sourceforge.net/projects/videlibri/files/Xidel/Xidel%200.9.8/xidel_0.9.8-1_amd64.deb
    sudo dpkg -i $APP_PATH/*.deb
    rm -f $APP_PATH/*.deb

    # js
    cd /tmp
    [ -e mujs ] && rm -rf mujs
    git clone https://github.com/ccxvii/mujs.git
    cd mujs
    make release
    sudo make install

    # audio
    cd /tmp
    sudo apt install zlib1g-dev libcunit1-dev libcunit1-dev git build-essential cmake
    [ -e libmysofa ] && rm -rf libmysofa
    git clone git clone https://github.com/hoene/libmysofa
    cd libmysofa/build
    cmake -DCMAKE_BUILD_TYPE=Debug ..
    make all test
    cd build && cpack
    sudo cmake install .

    # high-quality mpv
    echo "🎥 High-quality configuration for mpv"
    echo "Installing..."
    rm -rf "$CONFIG"

    # plugins

    # uosc
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/tomasklaen/uosc/HEAD/installers/unix.sh)"
    cp -rf $APP_PATH/mpv-config/* "$CONFIG"

    # sofa
    aria2c -c -j 8 -x 16 -s 16 -k 1M -d "$CONFIG" https://sofacoustics.org/data/database/clubfritz/ClubFritz6.sofa

    # webtorrent
    git clone https://github.com/noctuid/mpv-webtorrent-hook ~/.config/mpv/scripts/webtorrent-hook

    # imdb
    pip install --upgrade guessit git+https://github.com/cinemagoer/cinemagoer
    git clone --depth=1 https://github.com/ctlaltdefeat/mpv-open-imdb-page ~/.config/mpv/scripts/mpv-open-imdb-page
    git -C ~/.config/mpv/scripts/mpv-open-imdb-page pull

    break
  elif [[ $response =~ ^(n|N)=$ ]]
  then
    break
  else
    echo " What? \"$resp\" is not a correct answer. Try y+Enter."
  fi
done
