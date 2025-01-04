#!/bin/sh

RESTIC_PASSWORD_FILE=$GIT_PATH/linux-setup/appconfig/rclone/restic.txt
RESTIC_REPOSITORY=/media/$USER/AUTORESTIC/07.OS/linux-setup
LINUX_SETUP=$GIT_PATH/linux-setup

# init
[ ! -e "$RESTIC_REPOSITORY/linux-setup" ] && restic init --repo $RESTIC_REPOSITORY --password-file $RESTIC_PASSWORD_FILE

# backup
restic -r $RESTIC_REPOSITORY --verbose --password-file $RESTIC_PASSWORD_FILE backup $LINUX_SETUP

# restore: latest, 79766175
# restic -r $RESTIC_REPOSITORY restore latest --verbose --password-file $RESTIC_PASSWORD_FILE --target $LINUX_SETUP
