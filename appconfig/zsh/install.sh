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
    [[ -t 0 ]] && { read -t 10 -n 2 -p $'\e[1;32mInstall zshell (with athame)? [y/n] (default: '"$default"$')\e[0m\n' resp || resp=$default ; }
  fi
  response=`echo $resp | sed -r 's/(.*)$/\1=/'`

  if [[ $response =~ ^(y|Y)=$ ]]
  then

    sudo apt-get -y install curl

    # compile athame from sources
    cd $APP_PATH/../../submodules/athame

    NEOVIM="--vimbin=/usr/bin/vim"

    # build new zsh with readline patched with athame
    sudo ./zsh_athame_setup.sh --notest --use_sudo $NEOVIM

    rm -fr ~/.oh-my-zsh
    # install oh-my-zsh
    [ ! -e "$HOME/.oh-my-zsh" ] && sh -c "$(wget -c https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -) --unattended --keep-zshrc --skip-chsh"

    # symlink plugins
    if [ ! -e $HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting ]; then
      ln -sf $APP_PATH/../../submodules/zsh-syntax-highlighting $HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
    fi

    if [ ! -e $HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions ]; then
      ln -sf $APP_PATH/../../submodules/zsh-autosuggestions $HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions
    fi

    # add k plugin for zsh
    $APP_PATH/install_k_plugin.sh

    # symlink the .zshrc
    case $(< "$HOME/.zshrc") in *"dotzshrc"*) ;; *) cp "$APP_PATH/dotzshrc_template" "$HOME/.zshrc" ;; esac

    # add liquid prompt
    if [ ! -e $HOME/.liquidprompt ]; then
      git clone --branch stable https://github.com/nojhan/liquidprompt.git ~/.liquidprompt
    fi

    # bash line editor
    rm -fr /tmp/ble && mkdir /tmp/ble
    cd /tmp/ble

    git clone --recursive --depth 1 --shallow-submodules https://github.com/akinomyoga/ble.sh.git
    make -j8 -C ble.sh install PREFIX=~/.local

    # config
    # starship preset pure-preset -o ~/.config/starship.toml
    # rm -f ~/.config/starship.toml && cp $APP_PATH/starship.toml ~/.config/starship.toml

    break
  elif [[ $response =~ ^(n|N)=$ ]]
  then
    break
  else
    echo " What? \"$resp\" is not a correct answer. Try y+Enter."
  fi
done
