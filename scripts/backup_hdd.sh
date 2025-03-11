#!/bin/sh

set -e

# passkey
RESTIC_PASSWORD_FILE=$GIT_PATH/linux-setup/appconfig/rclone/restic.txt

# repos
CV_REPOSITORY=/media/$USER/AUTORESTIC/Documents/cvbuilder
LINUX_REPOSITORY=/media/$USER/AUTORESTIC/07.OS/linux-setup
LINUX_SETUP=$GIT_PATH/linux-setup
CV_SETUP=~/Documents/cvbuilder

# init
[ ! -e "$LINUX_REPOSITORY/config" ] && restic init --repo $LINUX_REPOSITORY --password-file $RESTIC_PASSWORD_FILE
[ ! -e "$CV_REPOSITORY/config" ] && restic init --repo $CV_REPOSITORY --password-file $RESTIC_PASSWORD_FILE

# backup
restic -r $LINUX_REPOSITORY --verbose --password-file $RESTIC_PASSWORD_FILE backup $LINUX_SETUP
restic -r $CV_REPOSITORY --verbose --password-file $RESTIC_PASSWORD_FILE backup $CV_SETUP

# restore: latest, 79766175
# restic -r $LINUX_REPOSITORY restore latest --verbose --password-file $RESTIC_PASSWORD_FILE --target $LINUX_SETUP
