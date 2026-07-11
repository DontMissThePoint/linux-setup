#!/bin/bash

# get the path to this script
APP_PATH=$(dirname "$0")
APP_PATH=$( (cd "$APP_PATH" && pwd))
SMART_VERSION=20.2
CONFIG="$HOME/.config/smartgit/$SMART_VERSION"

# syntevo
cd "$APP_PATH"

# wget -c https://download.smartgit.dev/smartgit/smartgit-26_1_038-linux_amd64.deb
wget -c https://www.syntevo.com/downloads/smartgit/archive/smartgit-20_2_6.deb

# Activate
toilet Setting up smartgit -t -f future

sudo dpkg -i *.deb || sudo apt install -fy
rm -fr "$APP_PATH"/*.deb ~/.config/smartgit
# sed -i 's/listx: {.*}/listx: {}/g' preferences.yml

# user
validate_email() {
    local email="$1"
    # regex for email validation
    [[ "$email" =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]
}

# Prompt
while true; do
    # Use printf for the prompt to avoid "no coprocess" errors in Zsh/Ksh
    printf "Enter your github email: "
    read -r user_email

    if validate_email "$user_email"; then
        echo "Updating..."
        break
    else
        echo "Sorry, try again."
    fi
done

# SSH key
if [ ! -e ~/.ssh/id_ed25519 ]; then
    echo "Generating a new SSH key..."
    ssh-keygen -t ed25519 -C "$user_email"
    eval "$(ssh-agent -s)"
    ssh-add ~/.ssh/id_ed25519
fi

# config
mkdir -p "$CONFIG"

ln -sf "$CONFIG"/preferences.yml ~/.smartgit-preferences.yml
pv "$APP_PATH"/smartgit.properties > "$CONFIG"/smartgit.properties
pv "$APP_PATH"/gitconfig >~/.gitconfig
pv ./ssh_config >~/.ssh/config
