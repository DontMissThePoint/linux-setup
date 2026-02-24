#!/bin/sh

set -e

# passkey
RESTIC_PASSWORD_FILE=$GIT_PATH/linux-setup/appconfig/syncthing/restic.txt

# repos
LINUX_REPOSITORY=rclone:mega:/07.OS/linux-setup
LINUX_SETUP=$GIT_PATH/linux-setup

# mount
echo "Connected ..."

# init
[ ! -e "$LINUX_REPOSITORY/config" ] && restic init --repo "$LINUX_REPOSITORY" --password-file "$RESTIC_PASSWORD_FILE"

# backup
restic -r "$LINUX_REPOSITORY" --verbose --password-file "$RESTIC_PASSWORD_FILE" backup "$LINUX_SETUP"

# restore: latest, 79766175
# restic -r $LINUX_REPOSITORY restore latest --verbose --password-file $RESTIC_PASSWORD_FILE --target $LINUX_SETUP

# umount
echo "Done."
