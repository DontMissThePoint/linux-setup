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
        [[ -t 0 ]] && { read -t 10 -n 2 -p $'\e[1;32mInstall TMUX? [y/n] (default: '"$default"$')\e[0m\n' resp || resp=$default; }
    fi
    response=$(echo "$resp" | sed -r 's/(.*)$/\1=/')

    if [[ $response =~ ^(y|Y)=$ ]]; then

        toilet Installing tmux -t --filter metal -f smmono12

        sudo apt-get -y remove tmux* || echo ""

        # compile and install custom tmux
        # cd $APP_PATH/../../submodules/tmux
        #( sh autogen.sh && ./configure && make && sudo make install-binPrograms ) || ( echo "Tmux compilation failed, installing normal tmux" && sudo apt-get -y install tmux)
        brew install -q tmux

        # plugins
        [ ! -e "$HOME/.tmux/plugins/tpm" ] && git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

        toilet Settingup tty -t -f future

        # timezone
        TIME_ZONE=$(timedatectl status | grep zone | awk '{ print $3 }')
        EXISTING_ZONE=$(grep -ow "zoneinfo" "$HOME/.profile" | wc -l)
        if [ "$EXISTING_ZONE" -lt "1" ]; then
            echo "Timezone set to $TIME_ZONE"
            (
                echo
                echo "export TZ=/usr/share/zoneinfo/$TIME_ZONE"
            ) >>~/.profile
        fi
        sudo apt -y install systemd-timesyncd
        timedatectl set-local-rtc 0 --adjust-system-clock

        # tty
        num=$(cat ~/.profile | grep "tty2" | wc -l)
        if [ "$num" -lt "1" ]; then

            echo "Automatically starting X after login"
            echo '
# start X after login
test -z "$DISPLAY" -a "$(tty)" = /dev/tty2 &&
            exec env XDG_VTNR=9 startx &>/dev/null' >>~/.profile

        fi

        #############################################
        # add TMUX enable/disable to .bashrc
        #############################################

        num=$(cat ~/.bashrc | grep "RUN_TMUX" | wc -l)
        if [ "$num" -lt "1" ]; then

            default=y
            while true; do
                if [[ "$unattended" == "1" ]]; then
                    resp=$default
                else
                    [[ -t 0 ]] && { read -t 10 -n 2 -p $'\e[1;32mDo you want to run TMUX automatically with every terminal? [y/n] (default: '"$default"$')\e[0m\n' resp || resp=$default; }
                fi
                response=$(echo "$resp" | sed -r 's/(.*)$/\1=/')

                if [[ $response =~ ^(y|Y)=$ ]]; then

                    echo "
# run Tmux automatically in every normal terminal
                    export RUN_TMUX=true" >>~/.bashrc

                    echo "Setting variable RUN_TMUX to true in .bashrc"

                    break
                elif [[ $response =~ ^(n|N)=$ ]]; then

                    echo "
# run Tmux automatically in every normal terminal
                    export RUN_TMUX=false" >>~/.bashrc

                    echo "Setting variable RUN_TMUX to false in .bashrc"

                    break
                else
                    echo " What? \"$resp\" is not a correct answer. Try y+Enter."
                fi
            done
        fi

        # tdab
        mkdir -p ~/.local/bin
        echo "Tmux devour style enabled."

        # session
        ln -sf "$APP_PATH"/tdab/tmux_devour.sh ~/.local/bin/devour
        ln -sf "$APP_PATH"/tdab/tmux_sidebar.sh ~/.local/bin/sidebar
        ln -sf "$APP_PATH"/tdab/tmux_topbar.sh ~/.local/bin/topbar
        ln -sf "$APP_PATH"/tdab/show-tmux-popup.sh ~/.local/bin/show-tmux-popup
        
        break
    elif [[ $response =~ ^(n|N)=$ ]]; then
        break
    else
        echo " What? \"$resp\" is not a correct answer. Try y+Enter."
    fi
done
