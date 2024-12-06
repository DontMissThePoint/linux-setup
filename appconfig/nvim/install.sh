#!/bin/bash

set -e

trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
trap 'echo "$0: \"${last_command}\" command failed with exit code $?"' ERR

# get the path to this script
APP_PATH=`dirname "$0"`
APP_PATH=`( cd "$APP_PATH" && pwd )`
CONFIG="$HOME/.config/nvim"
DATA="$HOME/.local/share/nvim"

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
    [[ -t 0 ]] && { read -t 10 -n 2 -p $'\e[1;32mInstall neovim? [y/n] (default: '"$default"$')\e[0m\n' resp || resp=$default ; }
  fi
  response=`echo $resp | sed -r 's/(.*)$/\1=/'`

  if [[ $response =~ ^(y|Y)=$ ]]
  then

    toilet Installing neovim -t --filter metal -f smmono12

    sudo apt-get -y remove neovim* || echo ""

    sudo apt-get -y install ninja-build gettext cmake unzip curl

    # compile neovim from sources
    rm -fr /tmp/nvim && mkdir /tmp/nvim && cd /tmp/nvim
    git clone https://github.com/neovim/neovim.git
    cd neovim
    make -j8 CMAKE_BUILD_TYPE=RelWithDebInfo \
    CMAKE_INSTALL_PREFIX=/usr/bin/nvim

    cd build && cpack -G DEB && sudo dpkg -i nvim-linux64.deb

    # nvim
    sudo -H pip3 install wheel

    sudo -H pip3 install neovim
    sudo -H pip3 install neovim-remote

    rm -rf "$DATA" "$CONFIG"

    # Nvchad
    git clone https://github.com/NvChad/starter "$CONFIG"
    echo "Use :Mason to install the language servers."
    cp -fr $APP_PATH/starter/lua/* $CONFIG/lua && nvim +MasonUpdate
    rm -fr "$CONFIG/.git"

    # syntevo smartGit
    echo "Setup syntevo tools."
    cd $APP_PATH
    # Previews:  https://www.syntevo.com/downloads/smartgit/smartgit-24_1-preview-8.deb
    wget -c https://www.syntevo.com/downloads/smartgit/archive/smartgit-20_2_6.deb

    # deepGit
    wget -c https://www.syntevo.com/downloads/deepgit/deepgit-4_4.deb

    # Activate
    sudo dpkg -i *.deb || sudo apt install -fy
    rm -fr $APP_PATH/*.deb ~/.config/smartgit
    num=`cat /usr/share/smartgit/bin/smartgit.sh | grep "NEW_DATE" | wc -l`
    if [ "$num" -lt "1" ]; then

        echo "Activating smartgit..."
        echo '
    # auto-reset trial period
    config="~/.config/smartgit/20.2/preferences.yml"
    # current date in msec + 25 days
    NEW_DATE=$(date -d"+25 days" +%s%3N)
    # sed is for change old date for new one in config
    sed -r -i "s/(listx: \{eUT: )[0-9]+/\1$NEW_DATE/g" $config
    sed -r -i "s/(, nRT: )[0-9]+/\1$NEW_DATE/g" $config' | \
        sudo tee -a /usr/share/smartgit/bin/smartgit.sh > /dev/null
        echo "Done."

    fi

    # ID
    cp -f ./ssh_config ~/.ssh/config

    break
  elif [[ $response =~ ^(n|N)=$ ]]
  then
    break
  else
    echo " What? \"$resp\" is not a correct answer. Try y+Enter."
  fi
done
