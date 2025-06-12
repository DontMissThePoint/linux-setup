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

    # use in pdfpc to play videos
    sudo apt-get -y install gstreamer1.0-libav gstreamer1.0-plugins-bad libxpresent1 timidity python3-dbus libmpdclient-dev

    # for video, photo, audio, ..., viewing and editing
    sudo apt-get remove -y --purge gimp vlc* audacity rawtherapee

    toilet Settingup ncmpcpp -t -f future

    # mpc
    cd /tmp
    [ -e mpc ] && sudo rm -rf mpc
    git clone https://github.com/MusicPlayerDaemon/mpc
    cd mpc
    meson setup build
    ninja -C build
    sudo ninja -C build install

    # mpd
    mkdir -p ~/.mpd/playlists
    pv "$APP_PATH/mpd.conf" >~/.mpd/mpd.conf
    mpc update

    # ncmpcpp
    sudo apt-get install -y ncmpcpp timg libnotify-bin inotify-tools libxres-dev screenkey pavucontrol
    sudo systemctl disable mpd.service mpd.socket
    mkdir -p ~/.config/ncmpcpp ~/.config/ncmpcpp/lyrics
    cp -fr --preserve "$APP_PATH"/ncmpcpp/* ~/.config/ncmpcpp/

    # mopidy
    sudo apt-get install -y mopidy mopidy-mpd mopidy-mpris mopidy-doc mopidy-podcast mopidy-local
    sudo systemctl disable mopidy.service
    sudo sed -i -e 's/^#*\s*\(load-module module-native-protocol-tcp\).*/\1 auth-ip-acl=127.0.0.1/g' \
      /etc/pulse/default.pa

    # yt-dlp
    /usr/bin/python3 -m pip install --break-system-packages -U pylast yt-dlp gallery-dl \
      Mopidy-Youtube Mopidy-Bookmarks Mopidy-Mowecl

    mkdir -p ~/.config/{yt-dlp,gallery-dl} ~/.config/{mopidy,podcast}
    pv "$APP_PATH/mopidy.conf" >~/.config/mopidy/mopidy.conf
    pv "$APP_PATH/Podcasts.opml" >~/.config/mopidy/podcast/Podcasts.opml
    pv "$APP_PATH/yt-dlp.conf" >~/.config/yt-dlp/yt-dlp.conf
    pv "$APP_PATH/config.json" >~/.config/gallery-dl/config.json

    # web; http://127.0.0.1:6680/
    echo "Scanning database..."
    mopidy local scan
    mopidy deps

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
    pip install --upgrade --break-system-packages guessit git+https://github.com/cinemagoer/cinemagoer
    git clone --depth=1 https://github.com/ctlaltdefeat/mpv-open-imdb-page ~/.config/mpv/scripts/mpv-open-imdb-page
    git -C ~/.config/mpv/scripts/mpv-open-imdb-page pull

    # autosubsync
    /usr/bin/python3 -m pip install --break-system-packages -U subliminal ffsubsync
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
