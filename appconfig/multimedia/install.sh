#!/bin/bash

set -e

trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
trap 'echo "$0: \"${last_command}\" command failed with exit code $?"' ERR

# get the path to this script
APP_PATH=$(dirname "$0")
APP_PATH=$( (cd "$APP_PATH" && pwd))
CONFIG="$HOME/.config/mpv"

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
[ "$var" = "24.04" ] && export NOBLE=1

default=y
while true; do
  if [[ "$unattended" == "1" ]]; then
    resp=$default
  else
    [[ -t 0 ]] && { read -t 10 -n 2 -p $'\e[1;32mInstall multimedia (players, ...)? [y/n] (default: '"$default"$')\e[0m\n' resp || resp=$default; }
  fi
  response=$(echo "$resp" | sed -r 's/(.*)$/\1=/')

  if [[ $response =~ ^(y|Y)=$ ]]; then

    toilet Installing multimedia -t --filter metal -f smmono12

    # ffmpeg
    cd /tmp
    wget -c -O ~/.local/bin/alass https://github.com/kaegi/alass/releases/download/v2.0.0/alass-linux64
    aria2c -c -j 8 -x 16 -s 16 -k 1M https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-amd64-static.tar.xz
    tar -xf ffmpeg-release-amd64-static.tar.xz
    cp ffmpeg-7.0.2-amd64-static/ff* ~/.local/bin
    sudo chmod 755 ~/.local/bin/ffmpeg
    sudo chmod 755 ~/.local/bin/ffprobe
    sudo chmod 755 ~/.local/bin/alass

    # jq
    cd /tmp
    [ -e jq ] && rm -rf jq
    git clone https://github.com/jqlang/jq
    cd jq
    git submodule update --init # if building from git to get oniguruma
    autoreconf -i               # if building from git
    ./configure --with-oniguruma=builtin
    make clean # if upgrading from a version previously built from source
    make -j8
    make check
    sudo make install

    # use in pdfpc to play videos
    sudo apt-get -y install gstreamer1.0-libav libxpresent1

    # for video, photo, audio, ..., viewing and editing
    sudo apt-get remove -y --purge gimp vlc* audacity rawtherapee

    # music
    toilet Settingup ncmpcpp -t -f future

    # mpd
    sudo apt-get install -y mpd mpc ncmpcpp timg libnotify-bin inotify-tools screenkey pavucontrol
    sudo systemctl disable mpd.service mpd.socket

    mkdir -p ~/.mpd
    pv "$APP_PATH/mpd.conf" >~/.mpd/mpd.conf

    # mopidy
    sudo apt-get install -y mopidy mopidy-mpd mopidy-mpris mopidy-doc mopidy-podcast mopidy-local
    sudo systemctl disable mopidy.service
    sudo sed -i -e 's/^#*\s*\(load-module module-native-protocol-tcp\).*/\1 auth-ip-acl=127.0.0.1/g' \
      /etc/pulse/default.pa

    mkdir -p ~/.config/mopidy ~/.config/mopidy/podcast
    pv "$APP_PATH/Podcasts.opml" >~/.config/mopidy/podcast/Podcasts.opml

    # ncmpcpp
    mkdir -p ~/.config/ncmpcpp ~/.config/ncmpcpp/lyrics
    cp -fr --preserve "$APP_PATH"/ncmpcpp/* ~/.config/ncmpcpp/

    #access the web UI
    # 127.0.0.1:6680/

    # mpv
    toilet Settingup mpv -t -f future

    # Add the repository to apt sources
    if [ ! -e /etc/apt/sources.list.d/fruit.list ]; then

      # Add mpv GPG key
      sudo curl --output-dir /etc/apt/trusted.gpg.d -O https://apt.fruit.je/fruit.gpg

      echo \
        "deb https://apt.fruit.je/ubuntu $(lsb_release -cs) mpv" |
        sudo tee /etc/apt/sources.list.d/fruit.list >/dev/null
      sudo apt-get update
      sudo apt install -y libopencore-amrnb0 libopencore-amrwb0 mpv-mpris mpv
    fi

    # high-quality mpv
    echo "🎥 High-quality configuration for mpv"
    echo "Installing..."
    rm -rf "$CONFIG"

    # uosc
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/tomasklaen/uosc/HEAD/installers/unix.sh)"
    cp -rf "$APP_PATH"/mpv-config/* "$CONFIG"

    # image-viewer
    echo "Installing mvi..."
    rm -fr ~/.config/mvi && cp -rf "$APP_PATH"/mvi ~/.config/
    mkdir -p ~/.cache/thumbnails/mpv-gallery

    # gallery-dl
    git clone https://github.com/noctuid/gallery-dl-view ~/.config/mvi/scripts/gallery-dl-view

    # webtorrent
    git clone https://github.com/noctuid/mpv-webtorrent-hook ~/.config/mpv/scripts/webtorrent-hook

    # imdb
    pip install --upgrade --break-system-packages guessit git+https://github.com/cinemagoer/cinemagoer 2>/dev/null
    git clone --depth=1 https://github.com/ctlaltdefeat/mpv-open-imdb-page ~/.config/mpv/scripts/mpv-open-imdb-page
    git -C ~/.config/mpv/scripts/mpv-open-imdb-page pull

    # autosubsync
    sudo pip install -U --break-system-packages subliminal ffsubsync 2>/dev/null
    git clone 'https://github.com/Ajatt-Tools/autosubsync-mpv' ~/.config/mpv/scripts/autosubsync

    # audio
    aria2c -c -j 8 -x 16 -s 16 -k 1M -d "$CONFIG" https://sofacoustics.org/data/database/clubfritz/ClubFritz6.sofa

    break
  elif [[ $response =~ ^(n|N)=$ ]]; then
    break
  else
    echo " What? \"$resp\" is not a correct answer. Try y+Enter."
  fi
done
