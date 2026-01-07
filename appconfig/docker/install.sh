#!/bin/bash

set -e

trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
trap 'echo "$0: \"${last_command}\" command failed with exit code $?"' ERR

# get the path to this script
APP_PATH=$(dirname "$0")
APP_PATH=$( (cd "$APP_PATH" && pwd))

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

default=y
while true; do
    if [[ "$unattended" == "1" ]]; then
        resp=$default
    else
        [[ -t 0 ]] && { read -t 10 -n 2 -p $'\e[1;32mInstall docker? [y/n] (default: '"$default"$')\e[0m\n' resp || resp=$default; }
    fi
    response=$(echo "$resp" | sed -r 's/(.*)$/\1=/')

    if [[ $response =~ ^(y|Y)=$ ]]; then

        toilet Installing docker -t --filter metal -f smmono12

        # packages
        for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove -y "$pkg"; done

        # sources
        if [ ! -e /etc/apt/sources.list.d/docker.list ]; then
            sudo apt-get update
            sudo apt-get install -y ca-certificates curl gnupg

            # GPG
            sudo install -m 0755 -d /etc/apt/keyrings
            curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
            sudo chmod a+r /etc/apt/keyrings/docker.gpg

            echo \
            "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
                $(lsb_release -cs) stable" |
            sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
            sudo apt-get update
        fi

        # docker
        sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
        sudo usermod -aG docker "$USER"

        # group
        num=$(cat /etc/group | cut -d: -f1 | grep "docker" | wc -l)
        if [ "$num" -lt "1" ]; then
            newgrp docker
        fi
        sudo systemctl enable docker
        sudo systemctl start docker

        # plugins
        mkdir -p "$HOME"/.docker
        curl -sSfL https://raw.githubusercontent.com/docker/scout-cli/main/install.sh | sh -s --
        curl -sSfL https://raw.githubusercontent.com/docker/sbom-cli-plugin/main/install.sh | sh -s --

        # freerdp
        echo "Setting up remote desktop"
        if [ ! -e /etc/apt/sources.list.d/freerdp-nightly.list ]; then

            # GPG key
            sudo install -m 0755 -d /etc/apt/keyrings
            wget -O - http://pub.freerdp.com/repositories/ADD6BF6D97CE5D8D.asc | sudo gpg --dearmor -o /etc/apt/keyrings/freerdp-nightly-ADD6BF6D97CE5D8D.gpg
            sudo chmod a+r /etc/apt/keyrings/freerdp-nightly-ADD6BF6D97CE5D8D.gpg

            echo \
            "deb [signed-by=/etc/apt/keyrings/freerdp-nightly-ADD6BF6D97CE5D8D.gpg] \
                http://pub.freerdp.com/repositories/deb/""$(lsb_release -cs)/ freerdp-nightly main" |
            sudo tee /etc/apt/sources.list.d/freerdp-nightly.list >/dev/null
            sudo apt-get update
        fi

        # docker
        sudo apt install -y freerdp-nightly docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

        ## kernel modules
        sudo apt install -y intel-media-va-driver mesa-utils linux-modules-extra-"$(uname -r)"
        sudo modprobe binder_linux devices="binder,hwbinder,vndbinder"
        sudo depmod -a

        # adb
        toilet Settingup adb -t -f future

        cd /tmp
        wget -c https://dl.google.com/android/repository/platform-tools-latest-linux.zip
        unzip \platform-tools-latest-linux.zip
        sudo cp platform-tools/adb /usr/lib/android-sdk/platform-tools/ ||
        sudo cp platform-tools/fastboot /usr/lib/android-sdk/platform-tools/

        # joplin
        toilet Settingup joplin -t -f future

        cp -rf "$APP_PATH"/Joplin ~/VirtualMachines/
        cd ~/VirtualMachines/Joplin
        docker compose pull
        # docker compose up -d
        # web: https://localhost:3001/
        mkdir -p ~/VirtualMachines/Joplin/config/Notes

        # calibre
        # Green: #b9edcd foreground: #384f45 links: #000000

        # yt
        mkdir -p ~/VirtualMachines/YoutubeDL-Material
        cd ~/VirtualMachines/YoutubeDL-Material
        curl -L https://github.com/Tzahi12345/YoutubeDL-Material/releases/latest/download/docker-compose.yml -o docker-compose.yml
        docker compose pull
        # youtubedl: http://localhost:8998/#/home

        # TX
        cd "$APP_PATH"/../fonts-powerline/fonts && mkdir -p patched
        docker run --rm \
            -v ./TX-02:/in \
            -v ./patched:/out \
            nerdfonts/patcher \
            --progressbars \
            --mono \
            --adjust-line-height \
            --fontawesome \
            --fontawesomeext \
            --fontlogos \
            --octicons \
            --codicons \
            --powersymbols \
            --pomicons \
            --powerline \
            --powerlineextra \
            --material \
            --weather
        cp -f patched/*.otf ~/.local/share/fonts/OTF
        rm -fr patched
        fc-cache -f -v

        # quickemu
        the_ppa=flexiondotorg/quickemu
        if ! grep -q "^deb .*$the_ppa" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
            sudo apt-add-repository ppa:flexiondotorg/quickemu
            sudo apt update
            sudo apt install -y bash coreutils ovmf grep jq lsb-base procps python3 genisoimage usbutils util-linux sed spice-client-gtk libtss2-tcti-swtpm0 wget xdg-user-dirs zsync unzip quickemu
            sudo apt install -y --no-install-recommends samba
        fi

        # VM
        mkdir -p ~/VirtualMachines/Windows-Docker
        # quickget windows 11
        # quickemu --vm windows-11.conf --width 1920 --height 1080
        # focus cell: #87ff87 #0088cc

        # 365
        # irm https://get.activated.win | iex

        # dockurr
        toilet Settingup dockurr -t -f future
        cp -f "$APP_PATH"/docker-compose.yml ~/VirtualMachines/Windows-Docker
        # docker compose stop
        # sudo docker compose up -d --force-recreate --build

        # docker system prune -af
        BGREEN='\033[1;32m'
        NC='\033[0m' # No Color
        echo -e "${BGREEN}> Windows active.${NC}"

        # calcpy
        echo "(Advanced math solver).. using Python IPython, SymPy"
        pipx install git+https://github.com/idanpa/calcpy

        # glances
        sudo apt install -y python3-psutil
        pipx install 'glances[all]'

        # config
        mkdir -p ~/.config/glances
        pv "$APP_PATH/glances.conf" >~/.config/glances/glances.conf

        break
    elif [[ $response =~ ^(n|N)=$ ]]; then
        break
    else
        echo " What? \"$resp\" is not a correct answer. Try y+Enter."
    fi
done
