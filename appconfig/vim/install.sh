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
        [[ -t 0 ]] && { read -t 10 -n 2 -p $'\e[1;32mInstall vim? [y/n] (default: '"$default"$')\e[0m\n' resp || resp=$default; }
    fi
    response=$(echo "$resp" | sed -r 's/(.*)$/\1=/')

    if [[ $response =~ ^(y|Y)=$ ]]; then

        toilet Installing vim -t --filter metal -f smmono12

        sudo apt-get -y remove vim-* || echo ""

        sudo apt-get -y install libncurses5-dev libgtk2.0-dev libatk1.0-dev libcairo2-dev libx11-dev libxpm-dev libxt-dev python3-dev clang-format libpython3-all-dev
	/home/linuxbrew/.linuxbrew/bin/brew unlink pkg-config libtool

        # libsodium
        cd /tmp
        [ -e libsodium ] && sudo rm -rf libsodium
        git clone https://github.com/jedisct1/libsodium --branch stable
        cd libsodium
	./configure
	make -j$(nproc) && make check
	sudo make install	

        # cache
        sudo ldconfig

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
            --with-ruby-command=/home/linuxbrew/.linuxbrew/bin/ruby \
            --with-tlib=ncurses \
            --enable-gui=no \
            --enable-cscope \
            --prefix=/usr

        cd src
        make -j$(nproc)
        cd ../
        make -j$(nproc) VIMRUNTIMEDIR=/usr/share/vim/vim91
        sudo make install

        # mergetool
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
		
                sudo apt-get -y install python3-clang libclang-20-dev

                # install prequisites for YCM
                sudo bash -c "$(wget -O - https://apt.llvm.org/llvm.sh)"

                # clangd
		sudo update-alternatives --install /usr/bin/clangd \
			clangd /usr/bin/clangd-"$(ls /usr/bin/clangd-* 2>/dev/null | grep -oE '[0-9]+$' | sort | tail -n1)" 999
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
		make -j$(nproc)
                sudo make install

                # config
                mkdir -p ~/.config/clipmenu
                pv "$APP_PATH/clipmenu.conf" >~/.config/clipmenu/clipmenu.conf

		# link
		/home/linuxbrew/.linuxbrew/bin/brew link pkg-config libtool
                echo "Done."

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
