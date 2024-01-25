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
    [[ -t 0 ]] && { read -t 10 -n 2 -p $'\e[1;32mInstall docker? [y/n] (default: '"$default"$')\e[0m\n' resp || resp=$default ; }
  fi
  response=`echo $resp | sed -r 's/(.*)$/\1=/'`

  if [[ $response =~ ^(y|Y)=$ ]]
  then

    toilet Installing docker

    # any conflict packages
    for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove -y $pkg; done

    # Add the repository to apt sources
    if [ ! -e /etc/apt/sources.list.d/docker.list ]; then
      sudo apt-get update
      sudo apt-get install -y ca-certificates curl gnupg

      # Add Docker's official GPG key
      sudo install -m 0755 -d /etc/apt/keyrings
      curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
      sudo chmod a+r /etc/apt/keyrings/docker.gpg

      echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
        $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
        sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
      sudo apt-get update
    fi

    # install docker
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

    # add group permission
    num=`cat /etc/group | cut -d: -f1 | grep "docker" | wc -l`
    if [ "$num" -lt "1" ]; then
      sudo groupadd docker
      sudo usermod -aG docker $USER
      groups $USER
    fi

    # quickemu
    sudo apt install -y qemu bash coreutils ovmf grep jq lsb-base procps python3 genisoimage usbutils util-linux sed spice-client-gtk libtss2-tcti-swtpm0 wget xdg-user-dirs zsync unzip

    the_ppa=flexiondotorg/quickemu
    if ! grep -q "^deb .*$the_ppa" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
       sudo apt-add-repository ppa:flexiondotorg/quickemu
       sudo apt update
       sudo apt install -y quickemu
    fi

    # virtual machine
    quickget windows 11
    quickemu --vm windows-11.conf

    break
  elif [[ $response =~ ^(n|N)=$ ]]
  then
    break
  else
    echo " What? \"$resp\" is not a correct answer. Try y+Enter."
  fi
done
