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

var=$(lsb_release -r | awk '{ print $2 }')
[ "$var" = "18.04" ] && export BEAVER=1

arch=$(uname -i)
#
# # ownership
# sudo chown -R "$USER": "$MY_PATH"
# find "$MY_PATH"/appconfig "$MY_PATH"/scripts -type f -iname '*.sh' | xargs sudo chmod +x
#
# # install packages
# sudo apt-get -y update -qq
#
# # essentials
# sudo apt-get -y install curl git git-lfs cmake-curses-gui build-essential automake autoconf autogen libgit2-dev libncurses5-dev libc++-dev pkg-config libx11-dev libconfig-dev libwayland-dev libtool net-tools libcurl4-openssl-dev libtiff-dev openssh-server nmap rsync gawk bison byacc pv atool moreutils
#
# # python
# sudo apt-get -y install python3-full python3-dev python3-setuptools python3-tk python3-pip
#
# if [ "$BEAVER" != "" ]; then
#     sudo apt-get -y install python-git
#     sudo ln -sf /bin/python2.7 /bin/python
# else
#     sudo apt-get -y install python3-git
# fi
#
# # other stuff
# sudo apt-get -y install ruby sl indicator-multiload figlet toilet gem tree exuberant-ctags xclip xsel exfat-fuse blueman autossh jq xvfb poppler-utils neofetch gparted cryptsetup xfsprogs gnome-shell-extensions gnome-control-center gnome-tweaks gpick espeak imagemagick ncdu bleachbit stacer wmctrl elinks libarchive-tools ffmpegthumbnailer multitail
#
# # submodules
# cd "$MY_PATH"
# "$docker" && git submodule update --init --recursive --recommend-shallow
# ! "$docker" && git submodule sync --recursive && git submodule update --remote --recursive || echo "Updating..."
# ! "$docker" && bash "$MY_PATH"/scripts/update-submodules.sh
#
# if [ "$unattended" == "0" ]; then
#     if [ "$?" != "0" ]; then echo "Press Enter to continue.." && read; fi
# fi
#
# # 1. Install NIX
# ! "$docker" && bash "$APPCONFIG_PATH"/nix/install.sh "$subinstall_params"
#
# # 2. Install LINUXBREW
# ! "$docker" && bash "$APPCONFIG_PATH"/brew/install.sh "$subinstall_params"
#
# # 3. Install TMUX
# ! "$docker" && bash "$APPCONFIG_PATH"/tmux/install.sh "$subinstall_params"
#
# # 4. Install ZSH with ATHAME
# ! "$docker" && bash "$APPCONFIG_PATH"/zsh/install.sh "$subinstall_params"
#
# # 5. Install URXVT
# ! "$docker" && bash "$APPCONFIG_PATH"/urxvt/install.sh "$subinstall_params"
#
# # 6. Install FONTS POWERLINE
# ! "$docker" && bash "$APPCONFIG_PATH"/fonts-powerline/install.sh "$subinstall_params"
#
# # 7. Install GO
# ! "$docker" && bash "$APPCONFIG_PATH"/go/install.sh "$subinstall_params"
#
# # 8. Install VIM
# ! "$docker" && bash "$APPCONFIG_PATH"/vim/install.sh "$subinstall_params"
#
# # 9. Install NVIM
# ! "$docker" && bash "$APPCONFIG_PATH"/nvim/install.sh "$subinstall_params"
#
# # 10. Install SYNCTHING
# ! "$docker" && bash "$APPCONFIG_PATH"/syncthing/install.sh "$subinstall_params"
#
# # 11. Install I3
# ! "$docker" && bash "$APPCONFIG_PATH"/i3/install.sh "$subinstall_params"
#
# # 12. Install HTOP-VIM
# ! "$docker" && bash "$APPCONFIG_PATH"/htop-vim/install.sh "$subinstall_params"
#
# # 13. Install MULTIMEDIA support
# ! "$docker" && bash "$APPCONFIG_PATH"/multimedia/install.sh "$subinstall_params"
#
# # 14. Setup RANGER
# ! "$docker" && bash "$APPCONFIG_PATH"/ranger/install.sh "$subinstall_params"
#
# # 15. Install ZATHURA
# ! "$docker" && bash "$APPCONFIG_PATH"/zathura/install.sh "$subinstall_params"
#
# # 16. Install VIMIV
# ! "$docker" && bash "$APPCONFIG_PATH"/vimiv/install.sh "$subinstall_params"
#
# # 17. Setup modified keyboard rules
# ! "$docker" && bash "$APPCONFIG_PATH"/keyboard/install.sh "$subinstall_params"
#
# # 18 Setup FZF
# ! "$docker" && bash "$APPCONFIG_PATH"/fzf/install.sh "$subinstall_params"
#
# # 19. Install VIM-STREAM
# ! "$docker" && bash "$APPCONFIG_PATH"/vim-stream/install.sh "$subinstall_params"
#
# # 20. Install LOLCAT
# ! "$docker" && bash "$APPCONFIG_PATH"/lolcat/install.sh "$subinstall_params"
#
# # 21. Install TMUXINATOR
# ! "$docker" && bash "$APPCONFIG_PATH"/tmuxinator/install.sh "$subinstall_params"
#
# # 22. Install REFIND
# if [ "$arch" != "aarch64" ]; then
#     ! "$docker" && bash "$APPCONFIG_PATH"/refind/install.sh "$subinstall_params"
# fi
#
# # 23. Install SCRCPY
# ! "$docker" && bash "$APPCONFIG_PATH"/scrcpy/install.sh "$subinstall_params"
#
# # 24. Install YT-X
# ! "$docker" && bash "$APPCONFIG_PATH"/yt-x/install.sh "$subinstall_params"
#
# # 25. Install KODI
# ! "$docker" && bash "$APPCONFIG_PATH"/lobster/install.sh "$subinstall_params"
#
# # 26. Install DOCKER
# ! "$docker" && bash "$APPCONFIG_PATH"/docker/install.sh "$subinstall_params"
#
# # 27. Install QUTEBROWSER
# ! "$docker" && bash "$APPCONFIG_PATH"/qutebrowser/install.sh "$subinstall_params"
#
# # the docker setup ends here
# if "$docker"; then
#     exit 0
# fi
#
# ##################################################
# # install inputs libraries when they are missing
# ##################################################
# sudo apt-get -y install xserver-xorg-input-all
#
# #############################################
# # Disable automatic update over apt
# #############################################
#
# sudo systemctl disable apt-daily.service
# sudo systemctl disable apt-daily.timer
#
# sudo systemctl disable apt-daily-upgrade.timer
# sudo systemctl disable apt-daily-upgrade.service
#
# #############################################
# # Disable basic telemetry
# #############################################
#
# sudo ufw logging off
#
# # Guest session / remote login
# sudo mkdir -p /etc/lightdm/lightdm.conf.d
# sudo sh -c 'printf "[SeatDefaults]\nallow-guest=false\ngreeter-show-remote-login=false\n" > \
    #     /etc/lightdm/lightdm.conf.d/50-no-guest.conf'
#
# #############################################
# # NETWORK
# #############################################
#
# num=$(grep -ow "^DNS" /etc/systemd/resolved.conf | wc -l)
# if [ "$num" -lt "1" ]; then
#
#     echo "Override DNS..."
#     # set bashrc
#     echo 'DNSSEC=no
# DNS=1.1.1.1 8.8.8.8 9.9.9.9
#     FallbackDNS=8.8.4.4' |
#     sudo tee -a /etc/systemd/resolved.conf >/dev/null
#
# fi
#
# #############################################
# # POWER
# #############################################
#
# the_ppa=linrunner/tlp
# if ! grep -q "^deb .*$the_ppa" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
#     sudo add-apt-repository -y ppa:linrunner/tlp
#     sudo apt update -qq
#     sudo apt -y install tlp tlp-rdw smartmontools
# fi
#
# sudo systemctl enable tlp.service
# sudo systemctl start tlp.service
#
# sudo systemctl mask systemd-rfkill.service
# sudo systemctl mask systemd-rfkill.socket
#
# #############################################
# # RAM
# #############################################
#
# sudo cp -v /usr/share/systemd/tmp.mount /etc/systemd/system
# sudo systemctl enable tmp.mount

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
# ycm
#############################################

ln -sf "$APPCONFIG_PATH"/clangd/dotclang-tidy ~/.clang-tidy

#############################################
# extras
#############################################

source "$APPCONFIG_PATH"/bash/dotbashrc_template

#############################################
# PROFILE
#############################################

# deploy configs by profile manager
cd "$MY_PATH" && ./deploy_configs.sh

#############################################
# STORAGE
#############################################

sudo apt -y autoremove
# topgrade || echo "Done."

#############################################
# SOURCE
#############################################

echo "Hurray, the 'Linux Setup' should be ready, try opening a new terminal."

#############################################
# rEFInd
#############################################

toilet All Done -t --filter metal -f mono9

# str=$(ps --no-headers -o comm 1)
# if [ "$str" = "systemd" ]; then
#     echo "Secure boot active.\nRebooting..."
#     sudo systemctl reboot --firmware-setup
# fi
