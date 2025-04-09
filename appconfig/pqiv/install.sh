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
    [[ -t 0 ]] && { read -t 5 -n 2 -p $'\e[1;32mInstall vimiv? [y/n] (default: '"$default"$')\e[0m\n' resp || resp=$default ; }
  fi
  response=`echo $resp | sed -r 's/(.*)$/\1=/'`

  if [[ $response =~ ^(y|Y)=$ ]]
  then

    toilet Installing pqiv -t --filter metal -f smmono12

    # install missing dependecies
    sudo apt-get -y install python3-setuptools

    # pqiv
    cd /tmp
    [ -e pqiv ] && sudo rm -rf pqiv
    git clone https://github.com/phillipberndt/pqiv
    cd pqiv
    ./configure && make -j8
    sudo make install

    echo "
[Desktop Entry]
Type=Application
Name=eog
GenericName=pqiv
Comment=Powerful image viewer with minimal UI
Icon=mpv
Terminal=false
Exec=pqiv
Categories=Graphics;GTK
MimeType=image/bmp;image/gif;image/jpeg;image/jp2;image/jpeg2000;image/jpx;image/png;image/svg;image/tiff;" | \
    sudo tee /usr/share/applications/pqiv.desktop > /dev/null
    xdg-mime default pqiv.desktop `grep 'MimeType=' /usr/share/applications/pqiv.desktop | sed -e 's/.*=//' -e 's/;/ /g'`

    # vimiv
    cd $APP_PATH/../../submodules/vimiv/
    sudo make install

    break
  elif [[ $response =~ ^(n|N)=$ ]]
  then
    break
  else
    echo " What? \"$resp\" is not a correct answer. Try y+Enter."
  fi
done
