#!/bin/sh

RESTIC_PASSWORD_FILE=$GIT_PATH/linux-setup/appconfig/rclone/restic.txt
RESTIC_REPOSITORY=/media/$USER/Envy/00-09.Library/07.OS

# restic init --repo $RESTIC_REPOSITORY --password-file $RESTIC_PASSWORD_FILE
restic -r $RESTIC_REPOSITORY --verbose --password-file $RESTIC_PASSWORD_FILE backup $GIT_PATH/linux-setup
