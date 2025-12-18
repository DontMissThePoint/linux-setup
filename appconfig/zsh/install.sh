#!/bin/bash set -e

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
        [[ -t 0 ]] && { read -t 10 -n 2 -p $'\e[1;32mInstall zshell (with athame)? [y/n] (default: '"$default"$')\e[0m\n' resp || resp=$default; }
    fi
    response=$(echo "$resp" | sed -r 's/(.*)$/\1=/')

    if [[ $response =~ ^(y|Y)=$ ]]; then

        toilet Settingup athame -t -f future

        sudo apt-get -y install curl

        # compile athame from sources
        cd "$APP_PATH"/../../submodules/athame

        NEOVIM="--vimbin=/usr/bin/vim"

        # build new zsh with readline patched with athame
        sudo ./zsh_athame_setup.sh --notest --use_sudo "$NEOVIM"

        # install oh-my-zsh
        [ ! -e "$HOME/.oh-my-zsh" ] && sh -c "$(wget -c https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -) --unattended --keep-zshrc --skip-chsh"

        # notify-urxvt
        if [ ! -e "$HOME"/.oh-my-zsh/custom/plugins/zsh-notify-urxvt ]; then
            git clone https://github.com/lpenz/zsh-notify-urxvt "$HOME"/.oh-my-zsh/custom/plugins/zsh-notify-urxvt
        fi

        # fzf-tab
        if [ ! -e "$HOME"/.oh-my-zsh/custom/plugins/fzf-tab ]; then
            git clone https://github.com/Aloxaf/fzf-tab "$HOME"/.oh-my-zsh/custom/plugins/fzf-tab
        fi

        # fish-completion
        if [ ! -e "$HOME"/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting ]; then
            ln -sf "$APP_PATH"/../../submodules/zsh-syntax-highlighting "$HOME"/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
        fi

        # auto-suggestions
        if [ ! -e "$HOME"/.oh-my-zsh/custom/plugins/zsh-autosuggestions ]; then
            ln -sf "$APP_PATH"/../../submodules/zsh-autosuggestions "$HOME"/.oh-my-zsh/custom/plugins/zsh-autosuggestions
        fi

        # k
        if [ ! -e "$HOME"/.oh-my-zsh/custom/plugins/k ]; then
            git clone https://github.com/supercrabtree/k "$HOME"/.oh-my-zsh/custom/plugins/k
        fi

        # symlink the .zshrc
        touch ~/.zshrc
        num=$(grep -ow "dotzshrc" "$HOME/.zshrc" | wc -l)
        if [ "$num" -lt "1" ]; then
            cp "$APP_PATH"/dotzshrc_template "$HOME"/.zshrc
        fi

        # symlink the .zprofile
        num=$(grep -ow "go" "$HOME/.zprofile" | wc -l)
        if [ "$num" -lt "1" ]; then
            cp "$APP_PATH"/zprofile_template "$HOME"/.zprofile
        fi
        echo -e "Adding configs\nDone."

        # liquid prompt
        if [ ! -e ~/.liquidprompt ]; then
            git clone --branch stable https://github.com/nojhan/liquidprompt.git ~/.liquidprompt
        fi

        # ble
        rm -fr /tmp/ble && mkdir /tmp/ble
        cd /tmp/ble

        git clone --recursive --depth 1 --shallow-submodules https://github.com/akinomyoga/ble.sh.git
        make -j8 -C ble.sh install PREFIX=~/.local

        # config
        # starship preset pure-preset -o ~/.config/starship.toml
        # rm -f ~/.config/starship.toml && cp $APP_PATH/starship.toml ~/.config/starship.toml

        # shell
        sudo usermod --shell "$(which zsh)" "$USER"

        break
    elif [[ $response =~ ^(n|N)=$ ]]; then
        break
    else
        echo " What? \"$resp\" is not a correct answer. Try y+Enter."
    fi
done
