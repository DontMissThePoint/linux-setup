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
        [[ -t 0 ]] && { read -t 10 -n 2 -p $'\e[1;32mSet up syncthing? (Encrypted backups, rclone) [y/n] (default: '"$default"$')\e[0m\n' resp || resp=$default; }
    fi
    response=$(echo "$resp" | sed -r 's/(.*)$/\1=/')

    if [[ $response =~ ^(y|Y)=$ ]]; then

        toilet Installing syncthing -t --filter metal -f smmono12

        # sources
        sudo rm -f /etc/apt/sources.list.d/syncthing.list

        # Syncthing
        sudo apt install -y gnupg2 curl apt-transport-https
        curl -fsSL https://syncthing.net/release-key.txt | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/syncthing.gpg
        echo "deb https://apt.syncthing.net/ syncthing stable" | sudo tee /etc/apt/sources.list.d/syncthing.list
        sudo apt update
        sudo apt install -y syncthing
        sudo systemctl enable syncthing@"$USER".service
        sudo systemctl start syncthing@"$USER".service
        # sudo systemctl status syncthing@$USER.service

        # open port 22000 firewall
        sudo ufw allow 22000/tcp

        #access the web UI
        # localhost:8384/
        mkdir -p ~/Journal ~/Documents/{Scorecard,Dashboard} ~/Pictures/Android\ Camera

        # Obsidian
        cd /tmp
        aria2c -c -j 8 -x 16 -s 16 -k 1M "$(wget -q -O - https://api.github.com/repos/obsidianmd/obsidian-releases/releases/latest |
        grep 'deb"$' | awk -F'"' ' {print $4} ')"
        sudo dpkg -i /tmp/obsidian*.deb
        mkdir -p ~/vaults/personal ~/vaults/work ~/vaults/.obsidian
        cp -fr "$APP_PATH"/dotobsidian/* ~/vaults/.obsidian
        pv "$APP_PATH"/obsidian.vimrc >~/vaults/.obsidian.vimrc

        # Rclone
        sudo apt install -y fuse3
        sudo -v
        wget https://rclone.org/install.sh | sudo bash || echo 'Configure cloud storage: Mega, GDrive, ... etc'
        # rclone config
        # rclone rcd --rc-web-gui

        # GDrive
        mkdir -p ~/.elinks
        pv "$APP_PATH"/elinks.conf >~/.elinks/elinks.conf
        pipx install gdown

        # MegaSync
        toilet Settingup megasync -t -f future

        # Add MEGA’s public signing key
        if [ ! -e /etc/apt/sources.list.d/megasync.list ]; then
            curl -fsSL "https://mega.nz/linux/repo/xUbuntu_$(lsb_release -r | awk '{ print $2 }')/Release.key" | gpg --dearmor |
            sudo tee /usr/share/keyrings/mega-nz.gpg >/dev/null
            sudo chmod a+r /usr/share/keyrings/mega-nz.gpg

            echo \
                "deb [signed-by=/usr/share/keyrings/mega-nz.gpg] \
                https://mega.nz/linux/repo/xUbuntu_$(lsb_release -r | awk '{ print $2 }')/ ./" |
            sudo tee /etc/apt/sources.list.d/megasync.list >/dev/null
            sudo apt-get update
        fi

        # MegaCMD
        sudo apt-get install -y megacmd megasync nautilus-megasync
        . "$APP_PATH"/dotsync.sh

        break
    elif [[ $response =~ ^(n|N)=$ ]]; then
        break
    else
        echo " What? \"$resp\" is not a correct answer. Try y+Enter."
    fi
done
