#!/bin/bash

set -e

trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
trap 'echo "$0: \"${last_command}\" command failed with exit code $?"' ERR

# get the path to this script
MY_PATH=$(dirname "$0")
MY_PATH=$( (cd "$MY_PATH" && pwd))

# define paths
APPCONFIG_PATH="$MY_PATH"/appconfig

subinstall_params=""
unattended=0
docker=false
for param in "$@"; do
    echo "$param"
    if [ "$param=--unattended" ]; then
        echo "installing in unattended mode"
        unattended=1
        subinstall_params="--unattended"
    fi
    if [ "$param=--docker" ]; then
        echo "installing in docker mode"
        docker=true
    fi
done
arch=$(uname -i)

# packages
sudo apt-get -y update -qq

# essentials
sudo apt-get -y install curl git git-lfs cmake-curses-gui build-essential automake autoconf autogen libgit2-dev libncurses5-dev libc++-dev pkg-config libx11-dev libconfig-dev libwayland-dev libtool net-tools libcurl4-openssl-dev libtiff-dev openssh-server nmap rsync gawk bison byacc pv atool wifi-qr moreutils xserver-xorg-input-all

# python
sudo apt-get -y install python3-full python3-dev python3-setuptools python3-tk python3-pip

if [ "$BEAVER" != "" ]; then
    sudo apt-get -y install python-git
    sudo ln -sf /bin/python2.7 /bin/python
else
    sudo apt-get -y install python3-git
fi

# other stuff
sudo apt-get -y install ruby sl indicator-multiload figlet toilet gem tree exuberant-ctags xclip xsel exfat-fuse blueman autossh jq xvfb poppler-utils neofetch gparted cryptsetup xfsprogs espeak imagemagick ncdu bleachbit stacer wmctrl elinks libarchive-tools ffmpegthumbnailer multitail

# submodules
cd "$MY_PATH"
! "$docker" && git submodule update --init --recursive --recommend-shallow
! "$docker" && git submodule sync --recursive && git submodule update --remote --recursive || echo "Updating..."
! "$docker" && bash "$MY_PATH"/scripts/update-submodules.sh

if [ "$unattended" == "0" ]; then
    if [ "$?" != "0" ]; then echo "Press Enter to continue.." && read; fi
fi

# 1. Install NIX
! "$docker" && bash "$APPCONFIG_PATH"/nix/install.sh "$subinstall_params"

# 2. Install LINUXBREW
! "$docker" && bash "$APPCONFIG_PATH"/brew/install.sh "$subinstall_params"

# 3. Install TMUX
! "$docker" && bash "$APPCONFIG_PATH"/tmux/install.sh "$subinstall_params"

# 4. Install ZSH with ATHAME
! "$docker" && bash "$APPCONFIG_PATH"/zsh/install.sh "$subinstall_params"

# 5. Install URXVT
! "$docker" && bash "$APPCONFIG_PATH"/urxvt/install.sh "$subinstall_params"

# 6. Install FONTS POWERLINE
! "$docker" && bash "$APPCONFIG_PATH"/fonts-powerline/install.sh "$subinstall_params"

# 7. Install GO
! "$docker" && bash "$APPCONFIG_PATH"/go/install.sh "$subinstall_params"

# 8. Install VIM
! "$docker" && bash "$APPCONFIG_PATH"/vim/install.sh "$subinstall_params"

# 9. Install NVIM
! "$docker" && bash "$APPCONFIG_PATH"/nvim/install.sh "$subinstall_params"

# 10. Install I3
! "$docker" && bash "$APPCONFIG_PATH"/i3/install.sh "$subinstall_params"

# 11. Install MULTIMEDIA support
! "$docker" && bash "$APPCONFIG_PATH"/multimedia/install.sh "$subinstall_params"

# 12. Setup RANGER
! "$docker" && bash "$APPCONFIG_PATH"/ranger/install.sh "$subinstall_params"

# 13. Install VIZ
! "$docker" && bash "$APPCONFIG_PATH"/viz/install.sh "$subinstall_params"

# 14. Install VIMIV
! "$docker" && bash "$APPCONFIG_PATH"/vimiv/install.sh "$subinstall_params"

# 15. Setup modified keyboard rules
! "$docker" && bash "$APPCONFIG_PATH"/xcape/install.sh "$subinstall_params"

# 16 Setup FZF
! "$docker" && bash "$APPCONFIG_PATH"/fzf/install.sh "$subinstall_params"

# 17. Install VIM-STREAM
! "$docker" && bash "$APPCONFIG_PATH"/vim-stream/install.sh "$subinstall_params"

# 18. Install LOLCAT
! "$docker" && bash "$APPCONFIG_PATH"/lolcat/install.sh "$subinstall_params"

# 19. Install TMUXINATOR
! "$docker" && bash "$APPCONFIG_PATH"/tmuxinator/install.sh "$subinstall_params"

# 20. Install REFIND
if [ "$arch" != "aarch64" ]; then
    ! "$docker" && bash "$APPCONFIG_PATH"/refind/install.sh "$subinstall_params"
fi

# 21. Install DOCKER
! "$docker" && bash "$APPCONFIG_PATH"/docker/install.sh "$subinstall_params"

# 22. Install ZEROBYTE
! "$docker" && bash "$APPCONFIG_PATH"/zerobyte/install.sh "$subinstall_params"

# 23. Install ADGUARD
! "$docker" && bash "$APPCONFIG_PATH"/adguard/install.sh "$subinstall_params"

# 24. Install QUTE
! "$docker" && bash "$APPCONFIG_PATH"/qute/install.sh "$subinstall_params"

# the docker setup ends here
if "$docker"; then
    exit 0
fi

#############################################
# apt
#############################################

sudo systemctl stop apt-daily-upgrade.timer
sudo systemctl stop apt-daily.timer

sudo systemctl disable apt-daily-upgrade.timer
sudo systemctl disable apt-daily.timer

#############################################
# telemetry
#############################################

sudo ufw logging off
sudo mkdir -p /etc/lightdm/lightdm.conf.d
sudo sh -c 'printf "[SeatDefaults]\nallow-guest=false\ngreeter-show-remote-login=false\n" > \
        /etc/lightdm/lightdm.conf.d/50-no-guest.conf'

#############################################
# ram
#############################################

sudo cp -v /usr/share/systemd/tmp.mount /etc/systemd/system
sudo systemctl enable tmp.mount

#############################################
# battery
#############################################

powerprofilesctl get
powerprofilesctl set performance

#############################################
# packages
#############################################

topgrade || echo "Up to date."

#############################################
# scripts
#############################################

if [ ! -e ~/.scripts ]; then
    ln -sf "$MY_PATH"/scripts ~/.scripts
fi

#############################################
# touchpad
#############################################

if [ ! -e /etc/X11/xorg.conf.d/90-touchpad.conf ]; then
    "$MY_PATH"/scripts/fix_touchpad_click.sh
fi
#############################################
# repo
#############################################

num=$(grep -ow "GIT_PATH" "$HOME/.bashrc" | wc -l)
if [ "$num" -lt "1" ]; then

    TEMP=$(cd "$MY_PATH/../" && pwd)

    echo "Adding GIT_PATH variable to .bashrc"
    # set bashrc
    echo "
# path to the git root
export GIT_PATH=$TEMP" >>~/.bashrc

fi

#############################################
# extras
#############################################

bash "$APPCONFIG_PATH"/bash/dotbashrc_template

#############################################
# ycm
#############################################

ln -sf "$APPCONFIG_PATH"/clangd/dotclang-tidy ~/.clang-tidy

#############################################
# display
#############################################

cd "$MY_PATH" && ./deploy_configs.sh
echo "Hurray, the 'Linux Setup' should be ready, try opening a new terminal."

toilet All Done -t --filter metal -f mono9
