#!/bin/bash

set -e

trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
trap 'echo "$0: \"${last_command}\" command failed with exit code $?"' ERR

# needs newer gtk
# GIRARA_VERSION=0.2.7
# ZATHURA_VERSION=0.3.7
# ZATHURA_PDF_POPPLER_VERSION=0.2.7

# 18.04
GIRARA_VERSION=0.2.6
ZATHURA_VERSION=0.3.6
ZATHURA_PDF_POPPLER_VERSION=0.2.7

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
    [[ -t 0 ]] && { read -t 5 -n 2 -p $'\e[1;32mInstall Zathura? [y/n] (default: '"$default"$')\e[0m\n' resp || resp=$default ; }
  fi
  response=`echo $resp | sed -r 's/(.*)$/\1=/'`

  if [[ $response =~ ^(y|Y)=$ ]]
  then

    if [ -n "$BEAVER" ]; then

      sudo apt-get -y remove zathura libgirara-dev
      sudo apt-get -y install libmagic-dev libsynctex1 libsynctex-dev libgtk-3-dev xdotool latexmk libpoppler-glib-dev

      sudo rm -rf /tmp/girara /tmp/zathura /tmp/zathura-pdf-poppler

      cd /tmp && git clone https://git.pwmt.org/pwmt/girara.git && cd girara && git checkout $GIRARA_VERSION && make && sudo make install
      cd /tmp && git clone https://git.pwmt.org/pwmt/zathura.git && cd zathura && git checkout $ZATHURA_VERSION && make WITH_SYNCTEX=1 && sudo make install
      cd /tmp && git clone https://github.com/pwmt/zathura-pdf-poppler.git && cd zathura-pdf-poppler && git checkout $ZATHURA_PDF_POPPLER_VERSION && make && sudo make install

      sudo rm -rf /tmp/girara /tmp/zathura /tmp/zathura-pdf-poppler

    else

      sudo apt-get -y install zathura mupdf mupdf-tools faketime xsltproc htmldoc libreoffice
    fi

    # zaread
    echo "Configuring..."
    sh -c "$(wget -O - https://sweetohm.net/dist/md2pdf/install)"
    mkdir -p ~/.config/zathura ~/.config/zaread
    pv "$APP_PATH/zareadrc" > ~/.config/zaread/zareadrc


    cd /tmp
    [ -e zaread ] && rm -rf zaread
    git clone https://github.com/paoloap/zaread
    cd zaread
    sudo make install

    # visidata
    pip install --upgrade visidata pypng pdfminer.six
    mkdir -p ~/.visidata
    cp -f $APP_PATH/plugins/* ~/.visidata
    pv "$APP_PATH/visidatarc" > ~/.visidatarc

    # epy
    pip install epy-reader

    # Calibre
    # Green scheme background: #b9edcd foreground: #384f45 links: #000000
    sudo -v && wget -nv -O- https://download.calibre-ebook.com/linux-installer.sh | sudo sh /dev/stdin
    #sudo calibre-uninstall

    # mimeapps
    pv $APP_PATH/mimeapps.list > ~/.config/mimeapps.list

    break
  elif [[ $response =~ ^(n|N)=$ ]]
  then
    break
  else
    echo " What? \"$resp\" is not a correct answer. Try y+Enter."
  fi
done
