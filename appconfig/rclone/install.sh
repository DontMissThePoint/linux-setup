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
    [[ -t 0 ]] && { read -t 10 -n 2 -p $'\e[1;32mSet up rclone? (Encrypted backups, restic, syncthing) [y/n] (default: '"$default"$')\e[0m\n' resp || resp=$default ; }
  fi
  response=`echo $resp | sed -r 's/(.*)$/\1=/'`

  if [[ $response =~ ^(y|Y)=$ ]]
  then

    sudo rm -f /etc/apt/sources.list.d/syncthing.list

    # Syncthing
    sudo apt install -y curl apt-transport-https
    curl -s https://syncthing.net/release-key.txt | sudo apt-key add -
    echo "deb https://apt.syncthing.net/ syncthing stable" | sudo tee /etc/apt/sources.list.d/syncthing.list
    sudo apt update
    sudo apt install -y syncthing
    sudo cp /etc/apt/trusted.gpg /etc/apt/trusted.gpg.d

    #access the web UI
    #https://localhost:8384/
    mkdir -p ~/Downloads/Syncthing

    # Obsidian
    cd /tmp
    aria2c -c -j 8 -x 16 -s 16 -k 1M https://github.com/obsidianmd/obsidian-releases/releases/download/v1.6.7/obsidian_1.6.7_amd64.deb
    sudo dpkg -i /tmp/obsidian_1.6.7_amd64.deb
    mkdir -p ~/vaults/personal ~/vaults/work ~/vaults/.obsidian
    cp -fr $APP_PATH/dotobsidian/* ~/vaults/.obsidian
    pv $APP_PATH/obsidian.vimrc > ~/vaults/.obsidian.vimrc

    # Rclone
    sudo apt install -y fuse3
    sudo -v ; wget https://rclone.org/install.sh | sudo bash || echo 'Configure cloud storage: Mega, GDrive, ...
$ rclone config'

    # Cloud
    # rclone config
    # rclone rcd --rc-web-gui

    # GDrive
    mkdir -p ~/.elinks
    pv $APP_PATH/elinks.conf > ~/.elinks/elinks.conf
    pip install --upgrade gdown

    break
  elif [[ $response =~ ^(n|N)=$ ]]
  then
    break
  else
    echo " What? \"$resp\" is not a correct answer. Try y+Enter."
  fi
done
