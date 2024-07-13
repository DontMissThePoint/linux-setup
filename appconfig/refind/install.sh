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

var=`lsb_release -r | awk '{ print $2 }'`
[ "$var" = "18.04" ] && export BEAVER=1
[ "$var" = "22.04" ] && export JAMMY=1

default=y
while true; do
  if [[ "$unattended" == "1" ]]
  then
    resp=$default
  else
    [[ -t 0 ]] && { read -t 10 -n 2 -p $'\e[1;32mInstall refind? [y/n] (default: '"$default"$')\e[0m\n' resp || resp=$default ; }
  fi
  response=`echo $resp | sed -r 's/(.*)$/\1=/'`

  if [[ $response =~ ^(y|Y)=$ ]]
  then

    toilet Installing refind

    the_ppa=rodsmith/refind
    if ! grep -q "^deb .*$the_ppa" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
      sudo add-apt-repository -y ppa:rodsmith/refind
      sudo apt update
      sudo apt install -y refind
    fi

    # grub-customizer
    if [ -n "$BEAVER" ] || [ -n "$JAMMY" ]; then
      the_ppa=danielrichter2007/grub-customizer
      if ! grep -q "^deb .*$the_ppa" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
        sudo add-apt-repository -y ppa:danielrichter2007/grub-customizer
        sudo apt update
        sudo apt install -y grub-customizer
      fi
    fi

    # plymouth
    sudo apt install -y plymouth
    sudo mkdir -p /etc/plymouth
    printf "[Daemon]\nTheme=lone\nShowDelay=0" | sudo tee /etc/plymouth/plymouthd.conf

    # install theme
    sudo cp -fr $APP_PATH/plymouth-themes/pack/lone /usr/share/plymouth/themes/
    sudo update-alternatives --install /usr/share/plymouth/themes/default.plymouth default.plymouth /usr/share/plymouth/themes/lone/lone.plymouth 200
    sudo update-alternatives --config default.plymouth
    sudo update-initramfs -c -k $(uname -r)
    sudo update-grub

    # refind2k
    cd /tmp
    [ -e refind2k ] && rm -rf refind2k
    git clone https://github.com/2kabhishek/refind2k.git
    cd refind2k
    sudo ./setup.sh
    # To uninstall refind2k run setup.sh with -u or --uninstall
    # ./setup.sh -u
    # To use a custom ESP, set the ESP envvar
    # ESP=/path/to/efi ./setup.sh
    # ESP=/path/to/efi ./setup.sh -u
    sudo refind-install
    sudo refind-mkdefault
    efibootmgr

    # uninstall
    # sudo rm -r /boot/efi/EFI/refind

    break
  elif [[ $response =~ ^(n|N)=$ ]]
  then
    break
  else
    echo " What? \"$resp\" is not a correct answer. Try y+Enter."
  fi
done
