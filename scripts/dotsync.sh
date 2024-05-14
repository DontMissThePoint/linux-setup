#!/bin/bash
# Last change : Wed 02 Aug 2023 11:29:26 AM EAT
# Use parallel

cp $GIT_PATH/linux-setup/appconfig/vim/dotmyvimrc $HOME/ownCloud/Documents/ACCOMPLISHED/dotfiles/.my.vimrc
cp $GIT_PATH/linux-setup/appconfig/tmux/dottmux.conf $HOME/ownCloud/Documents/ACCOMPLISHED/dotfiles/dottmux.conf
cp $GIT_PATH/linux-setup/appconfig/urxvt/dotXresources $HOME/ownCloud/Documents/ACCOMPLISHED/dotfiles/dotXresources
cp $GIT_PATH/linux-setup/appconfig/vim/dotvimrc $HOME/ownCloud/Documents/ACCOMPLISHED/dotfiles/dotvimrc
cp $GIT_PATH/linux-setup/appconfig/zsh/dotzshrc_template $HOME/ownCloud/Documents/ACCOMPLISHED/dotfiles/dotzshrc_template
cp $GIT_PATH/linux-setup/scripts/dotsync.sh $HOME/ownCloud/Documents/ACCOMPLISHED/dotfiles/dotsync.sh
cp $GIT_PATH/linux-setup/appconfig/go-whatsapp/dotgntrc $HOME/ownCloud/Documents/ACCOMPLISHED/dotfiles/.gntrc
cp $GIT_PATH/linux-setup/appconfig/fzf/dotFZF_DEFAULT_OPTS $HOME/ownCloud/Documents/ACCOMPLISHED/dotfiles/.FZF_DEFAULT_OPTS
cp $GIT_PATH/linux-setup/appconfig/qutebrowser/config_template.py $HOME/ownCloud/Documents/ACCOMPLISHED/dotfiles/config.py
cp $GIT_PATH/linux-setup/appconfig/zathura/zathurarc $HOME/ownCloud/Documents/ACCOMPLISHED/dotfiles/zathurarc
cp $GIT_PATH/linux-setup/appconfig/i3/doti3/config_git $HOME/ownCloud/Documents/ACCOMPLISHED/dotfiles/config_git

# Folders
cp -r $HOME/.config/i3-layout-manager/layouts $HOME/ownCloud/Documents/ACCOMPLISHED/
cp -r $HOME/Documents/rattle/* $HOME/ownCloud/Documents/ACCOMPLISHED/rattle
cp -r $HOME/.config/nvim/lua/custom/* $HOME/ownCloud/Documents/ACCOMPLISHED/dotfiles
rsync -ah --exclude '.git' $HOME/Documents/cvbuilder $HOME/ownCloud/Documents/ACCOMPLISHED/

# Notify
notify-send "Sync done!"
