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
    [[ -t 0 ]] && { read -t 10 -n 2 -p $'\e[1;32mInstall homebrew? [y/n] (default: '"$default"$')\e[0m\n' resp || resp=$default ; }
  fi
  response=`echo $resp | sed -r 's/(.*)$/\1=/'`

  if [[ $response =~ ^(y|Y)=$ ]]
  then

    # Brew
    num=`cat ~/.bashrc | grep "linuxbrew" | wc -l`
    if [ "$num" -lt "1" ]; then

      NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
      (echo; echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"') >> ~/.bashrc
      eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

    fi

    # exceed files limit
    ulimit -n2048

    # swiss knife
    toilet Setting up brew -t -f future
    source $HOME/.bashrc && brew update && brew upgrade
    brew install webtorrent-cli zoxide grc vivid fzf bat ripgrep universal-ctags miller ctop btop eza fd s-search dust zig aria2 glow restic croc
    brew cleanup --prune=all

    # configs
    echo "Configuring..."
    mkdir -p ~/.config/gitui ~/.config/btop ~/.config/bat ~/.aria2 ~/.config/aria2 ~/.config/glow ~/.config/s ~/.config/autorestic
    pv "$APP_PATH/key_bindings.ron" > ~/.config/gitui/key_bindings.ron
    pv "$APP_PATH/btop.conf" > ~/.config/btop/btop.conf
    pv "$APP_PATH/bat.config" > ~/.config/bat/config
    pv "$APP_PATH/s.config" > ~/.config/s/config
    pv "$APP_PATH/aria2.conf" > ~/.config/aria2/aria2.conf
    pv "$APP_PATH/glow.yml" > ~/.config/glow/glow.yml

    # update bt-trackers
    echo "Updating bt-trackers... "
    ~/linux-setup/scripts/aria2-trackers-update.sh

    # RPC extension: https://aria2e.com/
    # aria2c --enable-rpc --rpc-listen-all --max-concurrent-downloads=40 --max-connection-per-server=16 --min-split-size=20M --split=16 --continue=true --dir=/home/$USER/Downloads

    # servers
    curl -s http://mirrors.ubuntu.com/mirrors.txt | xargs -I {} sh -c 'echo $(curl -r 0-102400 -s -w %{speed_download} -o /dev/null {}/ls-lR.gz) {}' | sort -g -r | head -3 | awk '{ print $2  }'

    num=`cat /etc/apt/apt.conf.d/00aptitude | grep "Languages" | wc -l`
    if [ "$num" -lt "1" ]; then

        echo "Suppressing the language translation while updating..."
        echo 'Acquire::Languages "none";' | \
        sudo tee -a /etc/apt/apt.conf.d/00aptitude > /dev/null
        echo "Done."
    fi

    # apt-fast
    the_ppa=apt-fast/stable
    if ! grep -q "^deb .*$the_ppa" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
        sudo add-apt-repository -y ppa:apt-fast/stable
        sudo apt update -qq
        sudo apt -y install apt-fast
    fi

    # downloader
    sudo rm -f /usr/bin/aria2c
    sudo cp -f $APP_PATH/apt-fast.conf /etc/apt-fast.conf

    break
  elif [[ $response =~ ^(n|N)=$ ]]
  then
    break
  else
    echo " What? \"$resp\" is not a correct answer. Try y+Enter."
  fi
done
