#!/bin/bash

# get the path to this script
APP_PATH=$(dirname "$0")
APP_PATH=$( (cd "$APP_PATH" && pwd))

# syntevo
cd "$APP_PATH"

# Previews:  https://www.syntevo.com/downloads/smartgit/smartgit-24_1-preview-8.deb
wget -c https://www.syntevo.com/downloads/smartgit/archive/smartgit-20_2_6.deb

# deepGit
wget -c https://www.syntevo.com/downloads/deepgit/deepgit-4_4.deb

# Activate
toilet Setting up smartgit -t -f future

sudo dpkg -i *.deb || sudo apt install -fy
rm -fr "$APP_PATH"/*.deb ~/.config/smartgit
num=$(grep -c "NEW_DATE" </usr/share/smartgit/bin/smartgit.sh)
if [ "$num" -lt "1" ]; then

    echo "Activating..."
    echo '
# auto-reset trial period
config="~/.config/smartgit/20.2/preferences.yml"
# current date in msec + 25 days
NEW_DATE=$(date -d"+25 days" +%s%3N)
# sed is for change old date for new one in config
sed -r -i "s/(listx: \{eUT: )[0-9]+/\1$NEW_DATE/g" $config
    sed -r -i "s/(, nRT: )[0-9]+/\1$NEW_DATE/g" $config' |
    sudo tee -a /usr/share/smartgit/bin/smartgit.sh >/dev/null

fi

# Validate email
validate_email() {
    local email="$1"
    # regex for email validation
    [[ "$email" =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]
}

# Prompt
while true; do
    read -rp "Enter your github email: " user_email

    if validate_email "$user_email"; then
        echo "Valid email entered: $user_email"
        break
    else
        echo "OK."
    fi
done

# SSH key
if [ ! -e ~/.ssh/id_ed25519 ]; then
    echo "Generating a new SSH key..."
    ssh-keygen -t ed25519 -C "$user_email"
    eval "$(ssh-agent -s)"
    ssh-add ~/.ssh/id_ed25519
fi

# ID
cp -f ./ssh_config ~/.ssh/config
