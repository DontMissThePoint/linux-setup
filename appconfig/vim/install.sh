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

var1="18.04"
var2=$(lsb_release -r | awk '{ print $2 }')
[ "$var2" = "$var1" ] && export BEAVER=1

default=y
while true; do
    if [[ "$unattended" == "1" ]]; then
        resp=$default
    else
        [[ -t 0 ]] && { read -t 10 -n 2 -p $'\e[1;32mInstall vim? [y/n] (default: '"$default"$')\e[0m\n' resp || resp=$default; }
    fi
    response=$(echo "$resp" | sed -r 's/(.*)$/\1=/')

    if [[ $response =~ ^(y|Y)=$ ]]; then

        toilet Installing vim -t --filter metal -f smmono12

        sudo apt-get -y remove vim-* || echo ""

        if [ "$BEAVER" != "" ]; then
            sudo apt-get -y install libgnome2-dev libgnomeui-dev libbonoboui2-dev
        fi

        sudo apt-get -y install libncurses5-dev libgtk2.0-dev libatk1.0-dev libcairo2-dev libx11-dev libxpm-dev libxt-dev python3-dev clang-format libpython3-all-dev

        /usr/bin/python3 -m pip install --break-system-packages --ignore-installed rospkg

        # compile vim from sources
        cd "$APP_PATH"/../../submodules/vim
        make distclean
        ./configure --with-features=huge \
            --enable-multibyte \
            --enable-fontset \
            --with-python3-command=/usr/bin/python3 \
            --with-python3-config-dir=/usr/lib/python3.12/config-* \
            --enable-python3interp \
            --enable-perlinterp=yes \
            --enable-luainterp=yes \
            --enable-rubyinterp \
            --with-ruby-command="$(brew --prefix)"/bin/ruby \
            --with-tlib=ncurses \
            --enable-gui=no \
            --enable-cscope \
            --prefix=/usr

        cd src
        make -j8
        cd ../
        make -j8 VIMRUNTIMEDIR=/usr/share/vim/vim91
        sudo make install

        # set vim as a default git mergetool
        git config --global merge.tool vimdiff

        # symlink vim settings
        rm -rf ~/.vim
        ln -fs "$APP_PATH"/dotvim ~/.vim

        # Reset plug
        for dir in "$APP_PATH"/dotvim/plugged/*; do (cd "$dir" && git reset --hard origin/master && git checkout master); done || echo "It normally returns >0"

        # update: clean old plugins
        /usr/bin/vim -E -c "let g:user_mode=1" -c "so $APP_PATH/dotvimrc" -c "PlugInstall" -c "wqa" || echo "It normally returns >0"

        default=y
        while true; do
            if [[ "$unattended" == "1" ]]; then
                resp=$default
            else
                [[ -t 0 ]] && { read -t 10 -n 2 -p $'\e[1;32mCompile YouCompleteMe? [y/n] (default: '"$default"$')\e[0m\n' resp || resp=$default; }
            fi
            response=$(echo "$resp" | sed -r 's/(.*)$/\1=/')

            if [[ $response =~ ^(y|Y)=$ ]]; then

                # set youcompleteme
                toilet Settingup youcompleteme -t -f future

                # if not on 20.04, g++-8 has to be installed manually
                if [ "$BEAVER" != "" ]; then
                    sudo apt-get -y install g++-8
                    sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-7 700 --slave /usr/bin/g++ g++ /usr/bin/g++-7
                    sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-8 800 --slave /usr/bin/g++ g++ /usr/bin/g++-8
                    # add llvm repo for clangd and python3-clang
                    wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | sudo apt-key add -
                    sudo apt-add-repository "deb http://apt.llvm.org/bionic/ llvm-toolchain-bionic-11 main"
                    # if 18.04, python3-clang has to be installed throught pip3 with prequisites manually from apt
                    sudo apt-get -y install clang-11 libclang-11-dev
                    /usr/bin/python3 -m pip install --break-system-packages --ignore-installed clang
                else
                    # if 24.04, just install python3-clang from apt
                    sudo apt-get -y install python3-clang libclang-19-dev
                fi
                # install prequisites for YCM
                sudo bash -c "$(wget -O - https://apt.llvm.org/llvm.sh)"

                # set clangd to 18 latest by default
                sudo update-alternatives --install /usr/bin/clangd clangd /usr/bin/clangd-19 999
                sudo apt-get -y install libboost-all-dev

                cd ~/.vim/plugged
                rm -fr YouCompleteMe
                git clone https://github.com/ycm-core/YouCompleteMe
                cd YouCompleteMe
                git submodule update --init --recursive
                /usr/bin/python3 ./install.py --clangd-completer --verbose

                # link .ycm_extra_conf.py
                ln -fs "$APP_PATH"/dotycm_extra_conf.py ~/.ycm_extra_conf.py

                # clipmenu
                cd /tmp
                [ -e clipmenu ] && rm -rf clipmenu
                git clone https://github.com/cdown/clipmenu
                cd clipmenu
                make -j8
                sudo make install

                # store
                mkdir -p ~/.config/clipmenu
                pv "$APP_PATH/clipmenu.conf" >~/.config/clipmenu/clipmenu.conf

                break
            elif [[ $response =~ ^(n|N)=$ ]]; then
                break
            else
                echo " What? \"$resp\" is not a correct answer. Try y+Enter."
            fi
        done

        break
    elif [[ $response =~ ^(n|N)=$ ]]; then
        break
    else
        echo " What? \"$resp\" is not a correct answer. Try y+Enter."
    fi
done
