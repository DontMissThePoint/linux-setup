#!/bin/sh

set -e

# passkey
RESTIC_PASSWORD_FILE=$GIT_PATH/linux-setup/appconfig/syncthing/restic.txt

# repos
LINUX_REPOSITORY=/media/$USER/AUTORESTIC/07.OS/linux-setup
LINUX_SETUP=$GIT_PATH/linux-setup

# mount
udisksctl mount -b /dev/disk/by-label/AUTORESTIC || echo "Ready..."

# init
[ ! -e "$LINUX_REPOSITORY/config" ] && restic init --repo "$LINUX_REPOSITORY" --password-file "$RESTIC_PASSWORD_FILE"

# backup
restic -r "$LINUX_REPOSITORY" --verbose --password-file "$RESTIC_PASSWORD_FILE" backup "$LINUX_SETUP"

# restore: latest, 79766175
# restic -r $LINUX_REPOSITORY restore latest --verbose --password-file $RESTIC_PASSWORD_FILE --target $LINUX_SETUP

# umount
udisksctl unmount -b /dev/disk/by-label/AUTORESTIC
