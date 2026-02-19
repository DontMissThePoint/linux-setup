#!/bin/bash

set -e

trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
trap 'echo "$0: \"${last_command}\" command failed with exit code $?"' ERR

# get the path to this script
APP_PATH=$(dirname "$0")
APP_PATH=$( (cd "$APP_PATH" && pwd))

unattended=0
for param in "$@"; do
    echo "$param"
    if [ "$param=--unattended" ]; then
        echo "installing in unattended mode"
        unattended=1
        subinstall_params="--unattended"
    fi
done

var=$(lsb_release -r | awk '{ print $2 }')
[ "$var" = "18.04" ] && export BEAVER=1
[ "$var" = "24.04" ] && export NOBLE=1

default=y
while true; do
    if [[ "$unattended" == "1" ]]; then
        resp=$default
    else
        [[ -t 0 ]] && { read -t 10 -n 2 -p $'\e[1;32mInstall i3? [y/n] (default: '"$default"$')\e[0m\n' resp || resp=$default; }
    fi
    response=$(echo "$resp" | sed -r 's/(.*)$/\1=/')

    if [[ $response =~ ^(y|Y)=$ ]]; then

        toilet Installing i3 -t --filter metal -f smmono12

        sudo apt-get -y install libxcb1-dev libxcb-keysyms1-dev libpango1.0-dev libxcb-util0-dev libxcb-icccm4-dev libyajl-dev libstartup-notification0-dev libxcb-randr0-dev libev-dev libxcb-cursor-dev libxcb-xinerama0-dev libxcb-xkb-dev libxkbcommon-dev libxkbcommon-x11-dev autoconf libxcb-xrm0 libxcb-xrm-dev automake libxcb-shape0-dev libnotify-bin mpg123 dunst libkeybinder-3.0-0 redshift redshift-gtk libinput-tools vnstat vnstati

        if [ "$beaver" != "" ]; then
            sudo apt-get -y install python-keybinder gir1.2-keybinder
        fi

        # required for i3-layout-manager
        sudo apt-get -y install xdotool x11-xserver-utils indent libanyevent-i3-perl
        brew unlink pkg-config libtool

        # jq
        cd /tmp
        [ -e jq ] && rm -rf jq
        git clone https://github.com/jqlang/jq
        cd jq
        git submodule update --init # if building from git to get oniguruma
        autoreconf -i               # if building from git
        ./configure --with-oniguruma=builtin
        make clean # if upgrading from a version previously built from source
        make -j8
        make check
        sudo make install

        # zsv
        cd /tmp
        [ -e zsv ] && rm -rf zsv
        git clone https://github.com/liquidaty/zsv
        cd zsv
        ./configure
        make clean
        sudo make install

        if [ "$unattended" == "0" ] && [ "$TRAVIS" = "" ]; then # if running interactively

            UGREEN='\033[4;32m'
            NC='\033[0m' # No Color
            echo ""
            echo "-----------------------------------------------------------------"
            echo "installing custom tty font. it might require manual action."
            echo "-----------------------------------------------------------------"
            echo -e "if so, please select \"${UGREEN}10x18 (framebuffer only)${NC}\", after hitting enter"
            echo ""
            echo "waiting for enter..."
            echo ""
            read
        fi

        # console
        sudo dpkg-reconfigure -plow console-setup

        # ly backend
        sudo apt install -y build-essential libpam0g-dev libxcb-xkb-dev systemd

        # console
        cd /tmp
        [ -e ly ] && sudo rm -rf ly
        git clone https://github.com/fairyglade/ly
        cd ly
        zig build
        sudo "$(which zig)" build installexe -Dinit_system=systemd

        # auto-detect connected display
        cd /tmp
        [ -e autorandr-launcher ] && sudo rm -rf autorandr-launcher
        git clone https://github.com/smac89/autorandr-launcher
        cd autorandr-launcher
        sudo make install

        # restore graphical session properties
        cd /tmp
        [ -e autorandr ] && sudo rm -rf autorandr
        git clone https://github.com/phillipberndt/autorandr
        cd autorandr
        sudo make install

        #  service
        sudo systemctl daemon-reload
        sudo systemctl disable gdm3 getty@tty2.service
        sudo systemctl enable autorandr.service autorandr-lid-listener.service ly@tty1.service
        sudo cp -f "$APP_PATH"/config.ini /etc/ly/config.ini

        # udev
        sudo udevadm control --reload-rules

        # systemd & timers
        sudo mkdir -p /etc/X11/xinit/xinitrc.d
        sudo cp -f "$APP_PATH"/systemd/50-systemd-user.sh /etc/X11/xinit/xinitrc.d/50-systemd-user.sh
        sudo cp -f "$APP_PATH"/systemd/*.{service,timer} /usr/lib/systemd/user/
        systemctl --user daemon-reload
        systemctl --user --now enable autorandr_launcher.service
        systemctl --user --now enable pipewire pipewire-pulse wireplumber
        systemctl --user start xidlehook.service {update-submodules,bandwidth}.{service,timer}
        sudo systemctl --global enable xidlehook.service {update-submodules,bandwidth}.{service,timer}

        # vnstat
        sudo systemctl enable vnstat.service
        sudo systemctl start vnstat.service
        # journalctl --follow --identifier='autorandr-launcher-service'
        # systemctl --user list-timers

        # battery
        ln -sf "$APP_PATH"/battery-notif/batterynotif.sh ~/.local/bin/batterynotif

        # earlyoom
        sudo apt install -y earlyoom libkeyutils-dev
        sudo cp -f "$APP_PATH"/earlyoom /etc/default/earlyoom
        sudo systemctl restart earlyoom

        # scripts on startup
        sudo mkdir -p /etc/X11/xinit/xinitrc.d

        # gnome-shell-pomodoro
        num=$(gnome-shell --version | awk '{ print $3 }' | cut -c -2)

        sudo apt install -y meson gettext valac pkg-config desktop-file-utils appstream-util libappstream-glib-dev libglib2.0-dev gsettings-desktop-schemas-dev gobject-introspection libgirepository1.0-dev libsqlite3-dev libgom-1.0-dev libgstreamer1.0-dev libgtk-3-dev libcanberra-dev libpeas-dev libjson-glib-dev libunwind-dev gnome-shell-pomodoro-data

        cd /tmp
        [ -e gnome-pomodoro ] && rm -rf gnome-pomodoro
        git clone -b "gnome-$num" https://github.com/gnome-pomodoro/gnome-pomodoro.git
        cd gnome-pomodoro
        cp -f "$APP_PATH"/pomodoro-style.css ./data/resources/style.css
        meson setup . build --prefix=/usr
        meson compile -C build
        sudo meson install -C build --no-rebuild

        # compile i3 dependency which is not present in the repo
        sudo apt-get -y install libtool xutils-dev libpeas-dev libfftw3-dev libasound2-dev libpulse-dev libiniparser-dev libsdl2-2.0-0 libsdl2-dev libpipewire-0.3-dev libjack-jackd2-dev pkgconf

        # install light for display backlight control
        # compile light
        sudo apt-get -y install help2man
        cd "$APP_PATH"/../../submodules/light/
        ./autogen.sh
        ./configure && make -j8
        sudo make install
        # set the minimal backlight value to 5%
        light -n 5
        # clean up after the compilation
        make clean
        git clean -fd

        # i3
        sudo apt remove -y i3* || echo "Installing i3..."

        # compile i3
        /usr/bin/python3 -m pip install --break-system-packages meson
        # cd "$APP_PATH"/../../submodules/i3/
        sudo apt install -y i3status ninja-build

        # build from sources
        cd /tmp
        [ -e i3-gaps-rounded ] && rm -rf i3-gaps-rounded
        git clone https://github.com/jbenden/i3-gaps-rounded.git
        cd i3-gaps-rounded
        mkdir -p build && cd build
        meson ..
        ninja
        sudo ninja install

        # clean after myself
        git reset --hard
        git clean -fd

        # compile i3 blocks
        cd "$APP_PATH"/../../submodules/i3blocks/
        ./autogen.sh
        ./configure
        make
        sudo make install

        # clean after myself
        git reset --hard
        git clean -fd

        # for cpu usage in i3blocks
        sudo apt-get -y install sysstat dstat

        # for brightness and volume control
        sudo apt-get -y install xbacklight alsa-utils pulseaudio feh arandr

        arch=$(uname -i)
        if [ "$arch" != "aarch64" ]; then
            sudo apt-get -y install acpi
        fi

        # cava
        cd /tmp
        [ -e cava ] && rm -rf cava
        git clone https://github.com/karlstav/cava
        cd cava
        ./autogen.sh && ./configure
        make -j8
        sudo make install

        # snd_aloop
        echo "snd_aloop" |
        sudo tee /etc/modules-load.d/cava.conf >/dev/null

        # for making gtk look better
        sudo apt-get -y install lxappearance gtk-chtheme blueman polybar

        # polybar
        cp -fr --preserve "$APP_PATH"/polybar ~/.config/

        # pulseaudio-control
        sudo sed -i -e 's/^\(load-module module-stream-restore\).*/\1 restore_device=false/g' \
            /etc/pulse/default.pa
        ln -sf ~/.config/polybar/scripts/pulseaudio-control.sh ~/.local/bin/pulseaudio-control

        # flashfocus
        sudo apt-get -y install libxcb-render0-dev libffi-dev python3-dev python3-cffi
        pip install --break-system-packages flashfocus -U

        # xbanish
        cd /tmp
        [ -e xbanish ] && rm -rf xbanish
        git clone https://github.com/jcs/xbanish
        cd xbanish
        make -j8
        sudo make install

        # memory
        cd "$APP_PATH"/../../submodules/i3blocks-contrib/memory2
        make

        # symlink settings folder
        if [ ! -e ~/.i3 ]; then
            ln -sf "$APP_PATH"/doti3 ~/.i3
        fi

        # rofi
        sudo apt-get -y remove rofi* || echo "Installing rofi..."
        sudo apt install -y libxcb-ewmh-dev flex

        rm -fr /tmp/rofi && cd /tmp
        git clone https://github.com/davatorium/rofi.git
        cd rofi
        meson setup build -Dwayland=disabled
        ninja -C build -v
        sudo ninja -C build install

        # config
        echo "Configuring..."
        mkdir -p ~/.config/{dunst,flashfocus,rofi,cava}
        pv "$APP_PATH"/dunstrc >~/.config/dunst/dunstrc
        pv "$APP_PATH"/flashfocus.yml >~/.config/flashfocus/flashfocus.yml
        pv "$APP_PATH"/redshift.conf >~/.config/redshift.conf
        pv "$APP_PATH"/cava/config >~/.config/cava/config
        pv "$APP_PATH"/doti3/rofi/config.rasi >~/.config/rofi/config.rasi
        pv "$APP_PATH"/doti3/rofi/color.rasi >~/.config/rofi/color.rasi

        # i3
        pv "$APP_PATH"/doti3/config_git >~/.i3/config
        pv "$APP_PATH"/doti3/i3blocks.conf_git >~/.i3/i3blocks.conf
        pv "$APP_PATH"/i3blocks/wifi_git >"$APP_PATH"/i3blocks/wifi
        pv "$APP_PATH"/i3blocks/battery_git >"$APP_PATH"/i3blocks/battery

        # Xorg
        pv "$APP_PATH"/dotxinitrc >~/.xinitrc
        pv "$APP_PATH"/dotxsession >~/.xsession
        pv "$APP_PATH"/picom.conf >~/.config/picom.conf

        # GTK
        if [ -d "$HOME/.config/gtk-4.0" ]; then
            pv "$APP_PATH"/gtk.css >~/.config/gtk-4.0/gtk.css
            pv "$APP_PATH"/gtk-mine.css >~/.config/gtk-4.0/gtk-mine.css
            pv "$APP_PATH"/settings.ini >~/.config/gtk-4.0/settings.ini
        fi

        mkdir -p ~/.config/gtk-2.0
        pv "$APP_PATH"/gtkfilechooser.ini >~/.config/gtk-2.0/gtkfilechooser.ini
        pv "$APP_PATH"/settings.ini >~/.config/gtk-3.0/settings.ini
        pv "$APP_PATH"/gtk.css >~/.config/gtk-3.0/gtk.css
        pv "$APP_PATH"/gtk-mine.css >~/.config/gtk-3.0/gtk-mine.css
        pv "$APP_PATH"/dotgtkrc-2.0 >~/.gtkrc-2.0

        # autostart
        cd /etc/xdg/autostart/
        sudo sed -i 's/\(NoDisplay\)=true/\1=false/g' *.desktop
        chmod +x ~/.xinitrc

        # auto-login
        sudo sed -i -e 's/^#*\s*\(GRUB_DISABLE_OS_PROBER\).*/\1=true/g' \
            /etc/default/grub

        # lid
        sudo sed -i -e 's/^#*\s*\(HandleLidSwitch[^=]*\)=.*/\1=ignore/g' \
            /etc/systemd/logind.conf

        # copy fonts
        # fontawesome 4.7
        mkdir -p ~/.fonts
        cp "$APP_PATH"/fonts/* ~/.fonts/

        # link fonts.conf file
        mkdir -p ~/.config/fontconfig
        ln -sf "$APP_PATH"/fonts.conf ~/.config/fontconfig/fonts.conf

        # link layouts
        mkdir -p ~/.config/i3-layout-manager/layouts
        ln -sf "$APP_PATH"/layouts/* ~/.config/i3-layout-manager/layouts

        # install useful gui utils
        sudo apt-get -y install maim # (make image) takes screenshots

        "$APP_PATH"/make_launchers.sh "$APP_PATH"/../../scripts

        # nautilus
        gsettings set org.gnome.desktop.background show-desktop-icons false
        gsettings set org.gnome.desktop.peripherals.touchpad natural-scroll false

        # location
        sudo systemctl restart geoclue.service
        gsettings set org.gnome.system.location enabled false

        # install xkb layout state
        cd "$APP_PATH"/../../submodules/xkblayout-state/
        make
        sudo cp -f "$APP_PATH"/../../submodules/xkblayout-state/xkblayout-state /usr/bin/xkblayout-state
        rm -f xkblayout-state

        # required for i3lock-color
        sudo apt remove -y i3lock

        sudo apt install -y libpam0g-dev libcairo2-dev libfontconfig1-dev libxcb-composite0-dev libev-dev libx11-xcb-dev libxcb-xkb-dev libxcb-xinerama0-dev libxcb-randr0-dev libxcb-image0-dev libxcb-util-dev libxcb-xrm-dev libxkbcommon-dev libxkbcommon-x11-dev libjpeg-dev xscreensaver xscreensaver-data-extra xscreensaver-gl-extra libxc-dev libxss-dev libpulse-dev libxcb-screensaver0-dev glibc-tools libgif-dev

        # compile from sources
        cd /tmp
        [ -e i3lock-color ] && rm -rf i3lock-color
        git clone https://github.com/Raymo111/i3lock-color.git
        cd i3lock-color
        sudo ./install-i3lock-color.sh

        # fancy
        cd /tmp
        [ -e i3lock-fancy ] && rm -rf i3lock-fancy
        git clone https://github.com/meskarune/i3lock-fancy.git
        cd i3lock-fancy
        sudo make install

        # lockscreen with effects!
        wget -c https://raw.githubusercontent.com/betterlockscreen/betterlockscreen/main/install.sh -O - -q | sudo bash -s system latest true
        mkdir -p ~/.config/betterlockscreen/
        pv "$APP_PATH"/betterlockscreenrc >~/.config/betterlockscreen/betterlockscreenrc
        pv "$APP_PATH"/custom-post.sh >~/.config/betterlockscreen/custom-post.sh

        # [ falcon_heavy.jpg, lightning.jpg ]
        betterlockscreen -u "$APP_PATH"/../../miscellaneous/wallpapers/pexels-seun-oderinde.jpg

        # pipes.sh -t7
        sudo apt install -y cmatrix cmatrix-xfont
        cd /tmp
        [ -e pipes.sh ] && rm -rf /tmp/pipes.sh
        git clone https://github.com/pipeseroni/pipes.sh
        cd pipes.sh
        sudo make install

        # picom
        toilet Settingup picom -t -f future

        cd /tmp
        sudo apt install -y libxcb-damage0-dev libxcb-sync-dev libxcb-present-dev uthash-dev libpcre3 libpcre3-dev
        [ -e picom ] && rm -rf /tmp/picom
        git clone https://github.com/jonaburg/picom
        cd picom
        meson --buildtype=release . build
        ninja -C build
        sudo ninja -C build install

        # gpus
        # sudo apt-get -y install nvidia-prime
        brew link pkg-config libtool

        break
    elif [[ $response =~ ^(n|N)=$ ]]; then
        break
    else
        echo " What? \"$resp\" is not a correct answer. Try y+Enter."
    fi

done
