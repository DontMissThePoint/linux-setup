#!/bin/sh

set -e

# passkey
RESTIC_PASSWORD_FILE=$GIT_PATH/linux-setup/appconfig/syncthing/restic.txt

# repos
LINUX_REPOSITORY=rclone:mega:/07.OS/linux-setup
LINUX_SETUP=$GIT_PATH/linux-setup

# mount
echo -e "Connecting ...\nOK."

# init
num=$(rclone lsf mega:/07.OS/linux-setup | grep "config" | wc -l)
if [ "$num" -lt "1" ]; then
    echo "Initializing repo"
    restic init --repo "$LINUX_REPOSITORY" --password-file "$RESTIC_PASSWORD_FILE"
fi

# backup
restic -r "$LINUX_REPOSITORY" --verbose --password-file "$RESTIC_PASSWORD_FILE" backup "$LINUX_SETUP"

# restore: latest, 79766175
# restic -r $LINUX_REPOSITORY restore latest --verbose --password-file $RESTIC_PASSWORD_FILE --target $LINUX_SETUP

# umount
echo "Done."
