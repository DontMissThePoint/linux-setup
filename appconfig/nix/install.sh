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
        [[ -t 0 ]] && { read -t 10 -n 2 -p $'\e[1;32mInstall nixpkgs? [y/n] (default: '"$default"$')\e[0m\n' resp || resp=$default; }
    fi
    response=$(echo "$resp" | sed -r 's/(.*)$/\1=/')

    if [[ $response =~ ^(y|Y)=$ ]]; then

        toilet Settingup nix -t -f future

        # nix
        if [ ! -e /nix/receipt.json ]; then
            curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
        fi

        #subshell
        (
        	.  /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
        	
        	# packages
        	echo "Configuring..."
        	nix run home-manager/master -- init --switch
        	sed -i '/^ *home\.packages = \[ *$/,$d' ~/.config/home-manager/home.nix
        	cat "$APP_PATH"/pkgs.nix >>~/.config/home-manager/home.nix

        	# systemd
        	echo "Adding modules..."
        	echo -e "[Manager]\nManagerEnvironment=\"XDG_DATA_DIRS=/home/$USER/.nix-profile/share:/usr/local/share:/usr/share\"" |
        	tee ~/.config/systemd/user.conf >/dev/null

        	# icons
        	mkdir -p ~/.local/share/icons/hicolor/scalable/apps
        	rm -fr ~/.icons/default/index.theme
        	ln -sf ~/.nix-profile/share/applications/* ~/.local/share/applications/
        	ln -sf ~/.nix-profile/share/icons/hicolor/256x256/apps/* ~/.local/share/icons/hicolor/scalable/apps/

        	# home-manager
        	home-manager switch
        	sudo update-desktop-database
        	sudo -i determinate-nixd upgrade

        	# clean
        	nix store gc
        	echo "Done."
        	
        	# gpu
        	sudo $HOME/.nix-profile/bin/non-nixos-gpu-setup        	
        )

        # uninstall
        # /nix/nix-installer uninstall

        break
    elif [[ $response =~ ^(n|N)=$ ]]; then
        break
    else
        echo " What? \"$resp\" is not a correct answer. Try y+Enter."
    fi
done
