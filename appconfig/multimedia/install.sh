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
[ "$var" = "24.04" ] && export NOBLE=1

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

    toilet Installing multimedia

    # ffmpeg
    cd /tmp
    wget -c -O ~/.local/bin/alass https://github.com/kaegi/alass/releases/download/v2.0.0/alass-linux64
    aria2c -c -j 8 -x 16 -s 16 -k 1M https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-amd64-static.tar.xz
    tar -xf ffmpeg-release-amd64-static.tar.xz
    cp ffmpeg-7.0.1-amd64-static/ff* ~/.local/bin
    sudo chmod 755 ~/.local/bin/ffmpeg
    sudo chmod 755 ~/.local/bin/ffprobe
    sudo chmod 755 ~/.local/bin/alass

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
    sudo apt-get -y install gimp screenkey vlc audacity rawtherapee pavucontrol newsboat

    # newsboat
    cp -rf "$APP_PATH/newsboat" ~/.config/

    # mpv
    echo "Installing MPV"
    if [ -n "$FOCAL" ] || [ -n "$NOBLE" ]; then
      wget -c -P "$APP_PATH" https://apt.fruit.je/ubuntu/noble/mpv/mpv_0.38.0+fruit.1_amd64.deb
      wget -c -P "$APP_PATH" https://sourceforge.net/projects/videlibri/files/Xidel/Xidel%200.9.8/xidel_0.9.8-1_amd64.deb
      sudo dpkg -i $APP_PATH/*.deb
      rm -f $APP_PATH/*.deb
    else
      sudo apt install -y mpv
    fi

    # high-quality mpv
    echo "🎥 High-quality configuration for mpv"
    echo "Installing..."
    rm -rf "$CONFIG"

    # uosc
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/tomasklaen/uosc/HEAD/installers/unix.sh)"
    cp -rf $APP_PATH/mpv-config/* "$CONFIG"

    # image-viewer
    echo "Installing image-viewer"
    cp -rf $APP_PATH/mvi ~/.config/
    mkdir -p ~/.cache/thumbnails/mpv-gallery

    echo "
[Desktop Entry]
Type=Application
Name=mvi
GenericName=Image Viewer
Comment=An image viewer with mpv
Icon=mpv
Terminal=false
Exec=mpv --config-dir=$HOME/.config/mvi %U
Categories=Graphics;GTK
MimeType=image/bmp;image/gif;image/jpeg;image/jp2;image/jpeg2000;image/jpx;image/png;image/svg;image/tiff;" | \
    sudo tee /usr/share/applications/mvi.desktop > /dev/null
    xdg-mime default mvi.desktop `grep 'MimeType=' /usr/share/applications/mvi.desktop | sed -e 's/.*=//' -e 's/;/ /g'`

    # audio
    aria2c -c -j 8 -x 16 -s 16 -k 1M -d "$CONFIG" https://sofacoustics.org/data/database/clubfritz/ClubFritz6.sofa

    # gallery-dl
    git clone https://github.com/noctuid/gallery-dl-view ~/.config/mvi/scripts/gallery-dl-view

    # webtorrent
    git clone https://github.com/noctuid/mpv-webtorrent-hook ~/.config/mpv/scripts/webtorrent-hook

    # imdb
    pip install --upgrade guessit git+https://github.com/cinemagoer/cinemagoer
    git clone --depth=1 https://github.com/ctlaltdefeat/mpv-open-imdb-page ~/.config/mpv/scripts/mpv-open-imdb-page
    git -C ~/.config/mpv/scripts/mpv-open-imdb-page pull

    # autosubsync
    sudo pip install -U subliminal ffsubsync
    git clone 'https://github.com/Ajatt-Tools/autosubsync-mpv' ~/.config/mpv/scripts/autosubsync

    break
  elif [[ $response =~ ^(n|N)=$ ]]
  then
    break
  else
    echo " What? \"$resp\" is not a correct answer. Try y+Enter."
  fi
done
