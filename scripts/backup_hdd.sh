#!/bin/sh

set -e

# passkey
RESTIC_PASSWORD_FILE=$GIT_PATH/linux-setup/appconfig/zerobyte/restic.txt

# repos
RESTIC_REPOSITORY=/media/$USER/AUTORESTIC/07.OS/linux-setup
LINUX_SETUP=$GIT_PATH/linux-setup

# mount
udisksctl mount -b /dev/disk/by-label/AUTORESTIC || echo "Connected ..."

# init
[ ! -e "$RESTIC_REPOSITORY/config" ] && restic init --repo \
    "$RESTIC_REPOSITORY" --password-file "$RESTIC_PASSWORD_FILE"

# backup
restic -r "$RESTIC_REPOSITORY" --verbose --password-file \
    "$RESTIC_PASSWORD_FILE" backup "$LINUX_SETUP"

# restore: latest, 79766175
# restic -r $RESTIC_REPOSITORY restore latest --verbose --password-file $RESTIC_PASSWORD_FILE --target $LINUX_SETUP

# prune
restic -r "$RESTIC_REPOSITORY" forget --prune --password-file \
    "$RESTIC_PASSWORD_FILE" --keep-daily 7 --keep-weekly 4 --keep-monthly 12 --keep-yearly 3

# umount
udisksctl unmount -b /dev/disk/by-label/AUTORESTIC
