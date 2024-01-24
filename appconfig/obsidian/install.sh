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
    [[ -t 0 ]] && { read -t 10 -n 2 -p $'\e[1;32mSet up obsidian? [y/n] (default: '"$default"$')\e[0m\n' resp || resp=$default ; }
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

    sudo cp -f $APP_PATH/syncthing@.service /etc/systemd/system/syncthing@.service
    sudo systemctl daemon-reload
    sudo systemctl start syncthing@$USER
    sudo systemctl enable syncthing@$USER

    #access the web UI
    #https://localhost:8384/

    # Obsidian
    cd /tmp
    wget -c https://github.com/obsidianmd/obsidian-releases/releases/download/v1.4.16/obsidian_1.4.16_amd64.deb
    sudo dpkg -i obsidian_1.4.16_amd64.deb

    # Rclone
    sudo apt install -y fuse3
    sudo -v ; curl https://rclone.org/install.sh | sudo bash || echo "Setting up cloud storage."

    # config
    # rclone config
    # rclone rcd --rc-web-gui

    # daemon
    # sudo cp -f $APP_PATH/rclone-mega@.service /etc/systemd/system/rclone-mega@.service
    # sudo systemctl daemon-reload
    # sudo systemctl start rclone-mega@$USER
    # sudo systemctl enable --now rclone-mega@$USER

    break
  elif [[ $response =~ ^(n|N)=$ ]]
  then
    break
  else
    echo " What? \"$resp\" is not a correct answer. Try y+Enter."
  fi
done
