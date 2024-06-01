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

    # freerdp
    echo "Setup remote desktop..."
    if [ ! -e /etc/apt/sources.list.d/freerdp-nightly.list ]; then

      # GPG key
      sudo install -m 0755 -d /etc/apt/keyrings
      wget -O - http://pub.freerdp.com/repositories/ADD6BF6D97CE5D8D.asc | sudo gpg --dearmor -o /etc/apt/keyrings/freerdp-nightly-ADD6BF6D97CE5D8D.gpg
      sudo chmod a+r /etc/apt/keyrings/freerdp-nightly-ADD6BF6D97CE5D8D.gpg

      echo \
        "deb [signed-by=/etc/apt/keyrings/freerdp-nightly-ADD6BF6D97CE5D8D.gpg] \
http://pub.freerdp.com/repositories/deb/"$(. /etc/os-release && echo "$VERSION_CODENAME")"/ freerdp-nightly main" | \
        sudo tee /etc/apt/sources.list.d/freerdp-nightly.list > /dev/null
      sudo apt-get update
    fi

    # install docker
    sudo apt-get install -y freerdp-nightly docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin


    # quickemu
    sudo apt install -y qemu bash coreutils ovmf grep jq lsb-base procps python3 genisoimage usbutils util-linux sed spice-client-gtk libtss2-tcti-swtpm0 wget xdg-user-dirs zsync unzip
    sudo apt install -y --no-install-recommends samba

    the_ppa=flexiondotorg/quickemu
    if ! grep -q "^deb .*$the_ppa" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
       sudo apt-add-repository ppa:flexiondotorg/quickemu
       sudo apt update
       sudo apt install -y quickemu
    fi

    # VM
    mkdir -p ~/VirtualMachines/Windows-Docker
    # quickget windows 11
    # quickemu --vm windows-11.conf --width 1920 --height 1080

    # dockurr
    cp $APP_PATH/docker-compose.yml ~/VirtualMachines/Windows-Docker
    # docker compose up -d

    # guest DPI text : 125
    # desktop scale factor. This value MUST be ignored if it is less than 100%
    # or greater than 500% or deviceScaleFactor is not 100%, 140%, or 180%.

    # /opt/freerdp-nightly/bin/xfreerdp3 /f /u:Quickemu /p:******** /v:"$(hostname -I | awk '{print $1}')" /dynamic-resolution +decorations +fonts +aero +window-drag +multitransport +clipboard /floatbar:sticky:off /bpp:32 /audio-mode:0 /rfx /gfx:rfx /codec-cache:rfx /video /tune:FreeRDP_HiDefRemoteApp:true,FreeRDP_GfxAVC444v2:true,FreeRDP_GfxH264:true /scale-desktop:146 /scale-device:140

    break
  elif [[ $response =~ ^(n|N)=$ ]]
  then
    break
  else
    echo " What? \"$resp\" is not a correct answer. Try y+Enter."
  fi
done
