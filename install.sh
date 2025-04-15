#!/bin/bash

set -e

trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
trap 'echo "$0: \"${last_command}\" command failed with exit code $?"' ERR

# get the path to this script
MY_PATH=`dirname "$0"`
MY_PATH=`( cd "$MY_PATH" && pwd )`

# define paths
APPCONFIG_PATH=$MY_PATH/appconfig

subinstall_params=""
unattended=0
docker=false
for param in "$@"
do
  echo $param
  if [ $param="--unattended" ]; then
    echo "installing in unattended mode"
    unattended=1
    subinstall_params="--unattended"
  fi
  if [ $param="--docker" ]; then
    echo "installing in docker mode"
    docker=true
  fi
done

var=`lsb_release -r | awk '{ print $2 }'`
[ "$var" = "18.04" ] && export BEAVER=1

arch=`uname -i`

# ownership
sudo chown -R $USER: $MY_PATH
find $MY_PATH/appconfig $MY_PATH/scripts -type f -iname '*.sh' | xargs sudo chmod +x

# install packages
sudo apt-get -y update -qq

# essentials
sudo apt-get -y install curl git git-lfs cmake-curses-gui build-essential automake autoconf autogen libncurses5-dev libc++-dev pkg-config libconfig-dev libtool net-tools libcurl4-openssl-dev libtiff-dev openssh-server nmap rsync gawk bison byacc shellcheck pv atool moreutils

# python
sudo apt-get -y install python3-full python3-dev python3-setuptools python3-tk python3-pip

if [ -n "$BEAVER" ]; then
    sudo apt-get -y install python-git
    sudo ln -sf /bin/python2.7 /bin/python
  else
    sudo apt-get -y install python3-git
fi

# other stuff
sudo apt-get -y install ruby sl indicator-multiload figlet toilet gem tree exuberant-ctags xclip xsel exfat-fuse blueman autossh jq xvfb poppler-utils neofetch gparted cryptsetup xfsprogs gnome-shell-extensions gnome-control-center gnome-tweaks espeak imagemagick ncdu bleachbit stacer wmctrl elinks libarchive-tools ffmpegthumbnailer multitail

# submodules
cd $MY_PATH
$docker && git submodule update --init --recursive --recommend-shallow
! $docker && git submodule update --init --recursive

if [ "$unattended" == "0" ]
  then
    if [ "$?" != "0" ]; then echo "Press Enter to continue.." && read; fi
fi

# 1. Install NIX
! $docker && bash $APPCONFIG_PATH/nix/install.sh $subinstall_params

# 2. Install LINUXBREW
! $docker && bash $APPCONFIG_PATH/brew/install.sh $subinstall_params

# 3. Install TMUX
! $docker && bash $APPCONFIG_PATH/tmux/install.sh $subinstall_params

# 4. Install ZSH with ATHAME
! $docker && bash $APPCONFIG_PATH/zsh/install.sh $subinstall_params

# 5. Install URXVT
! $docker && bash $APPCONFIG_PATH/urxvt/install.sh $subinstall_params

# 6. Install FONTS POWERLINE
! $docker && bash $APPCONFIG_PATH/fonts-powerline/install.sh $subinstall_params

# 7. Install VIM
! $docker && bash $APPCONFIG_PATH/vim/install.sh $subinstall_params

# 8. Install NVIM
! $docker && bash $APPCONFIG_PATH/nvim/install.sh $subinstall_params

# 9. Install HTOP-VIM
! $docker && bash $APPCONFIG_PATH/htop-vim/install.sh $subinstall_params

# 10. Install I3
! $docker && bash $APPCONFIG_PATH/i3/install.sh $subinstall_params

# 11. Install LATEX and PDF support
! $docker && bash $APPCONFIG_PATH/latex/install.sh $subinstall_params

# 12. Install MULTIMEDIA support
! $docker && bash $APPCONFIG_PATH/multimedia/install.sh $subinstall_params

# 13. Setup RANGER
! $docker && bash $APPCONFIG_PATH/ranger/install.sh $subinstall_params

# 14. Install PANDOC
if [ "$arch" != "aarch64" ]; then
    ! $docker && bash $APPCONFIG_PATH/pandoc/install.sh $subinstall_params
fi

# 15. Install SHUTTER
if [ "$arch" != "aarch64" ]; then
    ! $docker && bash $APPCONFIG_PATH/shutter/install.sh $subinstall_params
fi

# 16. Install ZATHURA
! $docker && bash $APPCONFIG_PATH/zathura/install.sh $subinstall_params

# 17. Install PQIV
! $docker && bash $APPCONFIG_PATH/pqiv/install.sh $subinstall_params

# 18. Install SILVER SEARCHER (ag)
! $docker && bash $APPCONFIG_PATH/silver_searcher/install.sh $subinstall_params

# 19. Setup modified keyboard rules
! $docker && bash $APPCONFIG_PATH/keyboard/install.sh $subinstall_params

# 20. Setup fuzzyfinder
! $docker && bash $APPCONFIG_PATH/fzf/install.sh $subinstall_params

# 21. Install PLAYERCTL
if [ "$arch" != "aarch64" ]; then
    ! $docker && bash $APPCONFIG_PATH/playerctl/install.sh $subinstall_params
fi

# 22. Install PAPIS
! $docker && bash $APPCONFIG_PATH/papis/install.sh $subinstall_params

# 23. Install VIM-STREAM
! $docker && bash $APPCONFIG_PATH/vim-stream/install.sh $subinstall_params

# 24. Install REFIND
if [ "$arch" != "aarch64" ]; then
    ! $docker && bash $APPCONFIG_PATH/refind/install.sh $subinstall_params
fi

# 25. Install TMUXINATOR
! $docker && bash $APPCONFIG_PATH/tmuxinator/install.sh $subinstall_params

# 26. Install LOLCAT
! $docker && bash $APPCONFIG_PATH/lolcat/install.sh $subinstall_params

# 27. Install DOCKER
! $docker && bash $APPCONFIG_PATH/docker/install.sh $subinstall_params

# 28. Install YT-DLP
! $docker && bash $APPCONFIG_PATH/yt-dlp/install.sh $subinstall_params

# 29. Install LOBSTER
! $docker && bash $APPCONFIG_PATH/lobster/install.sh $subinstall_params

# 30. Install SCRCPY
! $docker && bash $APPCONFIG_PATH/scrcpy/install.sh $subinstall_params

# 31. Install NCHAT
! $docker && bash $APPCONFIG_PATH/nchat/install.sh $subinstall_params

# 32. Install SYNCTHING
! $docker && bash $APPCONFIG_PATH/syncthing/install.sh $subinstall_params

# 33. Install QUTEBROWSER
! $docker && bash $APPCONFIG_PATH/qutebrowser/install.sh $subinstall_params

# the docker setup ends here
if $docker; then
  exit 0
fi

##################################################
# install inputs libraries when they are missing
##################################################
sudo apt-get -y install xserver-xorg-input-all

#############################################
# Disable automatic update over apt
#############################################

sudo systemctl disable apt-daily.service
sudo systemctl disable apt-daily.timer

sudo systemctl disable apt-daily-upgrade.timer
sudo systemctl disable apt-daily-upgrade.service

#############################################
# Disable basic telemetry
#############################################

sudo apt-get -y purge unity-lens-shopping unity-webapps-common
sudo apt-get -y purge zeitgeist zeitgeist-core zeitgeist-datahub
sudo apt-get -y purge apturl ubuntu-advantage-tools

# disable firewall log
sudo ufw logging off

# Guest session & remote login disable for LightDm
sudo mkdir -p /etc/lightdm/lightdm.conf.d
sudo sh -c 'printf "[SeatDefaults]\nallow-guest=false\ngreeter-show-remote-login=false\n" > \
  /etc/lightdm/lightdm.conf.d/50-no-guest.conf'

#############################################
# Optimize for performance
#############################################

# path
# remove_duplicates_from_path

# network
case $(< /etc/systemd/resolved.conf 2>/dev/null) in
  *"^DNS"*)
    ;;
  *)
    echo "Override DNS..."
    echo -e \
      "DNS=1.1.1.1 8.8.8.8 \
      \nFallbackDNS=8.8.4.4" | \
      sudo tee -a /etc/systemd/resolved.conf > /dev/null
    ;;
esac

# storage
topgrade
sudo apt -y autoremove
sudo docker volume prune

# power
the_ppa=linrunner/tlp
if ! grep -q "^deb .*$the_ppa" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
    sudo add-apt-repository -y ppa:linrunner/tlp
    sudo apt update -qq
    sudo apt -y install tlp tlp-rdw smartmontools
fi

sudo systemctl enable tlp.service
sudo systemctl start tlp.service

sudo systemctl mask systemd-rfkill.service
sudo systemctl mask systemd-rfkill.socket

#############################################
# use temporary folder in RAM
#############################################

sudo cp -v /usr/share/systemd/tmp.mount /etc/systemd/system
sudo systemctl enable tmp.mount

#############################################
# link the scripts folder
#############################################

if [ ! -e ~/.scripts ]; then
    ln -sf $MY_PATH/scripts ~/.scripts
fi

#############################################
# fix touchpad touch-clicking
#############################################

if [ ! -e /etc/X11/xorg.conf.d/90-touchpad.conf ]; then
    $MY_PATH/scripts/fix_touchpad_click.sh
fi

#############################################
# link dotclang-tidy to ~/.clang-tidy
# (enable linting for YCM)
#############################################
ln -sf "$APPCONFIG_PATH/clangd/dotclang-tidy" ~/.clang-tidy

# deploy configs by Profile manager
cd $MY_PATH && ./deploy_configs.sh

## bashrc extras
source "$APPCONFIG_PATH/bash/dotbashrc_template"

# finally source the correct rc file
toilet All Done -t --filter metal -f mono9

# say some tips to the new user
echo "Hurray, the 'Linux Setup' should be ready, try opening a new terminal."

#############################################
# set rEFInd boot
#############################################

str=`ps --no-headers -o comm 1`
if [ "$str" = "systemd" ]; then
  echo "rEFInd boot manager options"
  echo "Rebooting... to EFI setup"
  sudo systemctl reboot --firmware-setup
fi
