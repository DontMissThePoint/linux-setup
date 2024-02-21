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

var1="18.04"
var2=`lsb_release -r | awk '{ print $2 }'`
[ "$var2" = "$var1" ] && export BEAVER=1

default=y
while true; do
  if [[ "$unattended" == "1" ]]
  then
    resp=$default
  else
    [[ -t 0 ]] && { read -t 10 -n 2 -p $'\e[1;32mSet up pandoc? [y/n] (default: '"$default"$')\e[0m\n' resp || resp=$default ; }
  fi
  response=`echo $resp | sed -r 's/(.*)$/\1=/'`

  if [[ $response =~ ^(y|Y)=$ ]]
  then

    if [ -n "$BEAVER" ]; then
      cd /tmp
      aria2c -c -j 8 -x 16 -s 16 -k 1M https://github.com/jgm/pandoc/releases/download/3.1.10/pandoc-3.1.10-1-amd64.deb
      sudo dpkg -i pandoc-3.1.10-1-amd64.deb
    else
      sudo apt install -y pandoc
    fi

    # epy
    pip3 install epy-reader

    # Calibre
    sudo -v && wget -nv -O- https://download.calibre-ebook.com/linux-installer.sh | sudo sh /dev/stdin
    #sudo calibre-uninstall

    # Green scheme background: #b9edcd foreground: #384f45 links: #000000

    # xdg-open
    cp -f $APP_PATH/mimeapps.list ~/.config/mimeapps.list

    # Kodoo
    # cd /tmp
    # aria2c -c -j 8 -x 16 -s 16 -k 1M https://github.com/koodo-reader/koodo-reader/releases/download/v1.6.0/Koodo.Reader-1.6.0-amd64.deb
    # sudo dpkg -i Koodo.Reader-1.6.0-amd64.deb

    break

  elif [[ $response =~ ^(n|N)=$ ]]
  then
    break
  else
    echo " What? \"$resp\" is not a correct answer. Try y+Enter."
  fi
done
