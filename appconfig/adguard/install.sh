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
        [[ -t 0 ]] && { read -t 10 -n 2 -p $'\e[1;32mInstall adguard (Ad blocking, stream movie)? [y/n] (default: '"$default"$')\e[0m\n' resp || resp=$default; }
    fi
    response=$(echo "$resp" | sed -r 's/(.*)$/\1=/')

    if [[ $response =~ ^(y|Y)=$ ]]; then

        toilet Installing adguard -t --filter metal -f smmono12

        # adguard
        if [ ! -e /etc/systemd/system/AdGuardHome.service ]; then
            curl -s -S -L https://raw.githubusercontent.com/AdguardTeam/AdGuardHome/master/scripts/install.sh | sh -s -- -v
        fi

        # DNS=1.1.1.1 8.8.8.8 9.9.9.9
				# http://127.0.0.1:3000
        num=$(grep -ow "^DNS" /etc/systemd/resolved.conf | wc -l)
        if [ "$num" -lt "1" ]; then

            echo "Override DNS..."
            # set bashrc
            echo 'DNSSEC=no
DNSStubListener=no
DNS=127.0.0.1
FallbackDNS=8.8.4.4' |
            sudo tee -a /etc/systemd/resolved.conf >/dev/null

        fi
        sudo sed -i 's/3/2/' /etc/NetworkManager/conf.d/*
        sudo service systemd-resolved restart

        # lobster
        curl -sL github.com/justchokingaround/lobster/raw/main/lobster.sh -o "$(brew --prefix)"/bin/lobster &&
        chmod +x "$(brew --prefix)"/bin/lobster

        # ueberzug
        sudo ln -sf ~/.nix-profile/bin/ueberzugpp /usr/local/bin/ueberzug
        sudo ln -sf /opt/AdGuardHome/AdGuardHome /usr/local/bin/adguard

        # libg-fzf
        echo "Adding Library Genesis.."
        sudo curl -sL https://raw.githubusercontent.com/mrishu/libg-fzf/main/libg -o /usr/local/bin/libg &&
        sudo chmod +x /usr/local/bin/libg

        # config
        mkdir -p ~/.config/{lobster,libg}
        pv "$APP_PATH/lobster_config.txt" >~/.config/lobster/lobster_config.txt
        pv "$APP_PATH/libg.sh" >~/.config/libg/libg.sh

        break
    elif [[ $response =~ ^(n|N)=$ ]]; then
        break
    else
        echo " What? \"$resp\" is not a correct answer. Try y+Enter."
    fi
done
