#!/bin/sh

set -e

# passkey
RESTIC_PASSWORD_FILE=$GIT_PATH/linux-setup/appconfig/syncthing/restic.txt

# repos
CV_TEX_REPO=/media/$USER/AUTORESTIC/Documents/cvbuilder
CV_JS_REPO=/media/$USER/AUTORESTIC/Documents/cvjs
LINUX_REPOSITORY=/media/$USER/AUTORESTIC/07.OS/linux-setup
LINUX_SETUP=$GIT_PATH/linux-setup
CV_TEX=~/Documents/cvbuilder
CV_JS=~/Documents/cvjs

# init
[ ! -e "$LINUX_REPOSITORY/config" ] && restic init --repo $LINUX_REPOSITORY --password-file $RESTIC_PASSWORD_FILE
[ ! -e "$CV_TEX_REPO/config" ] && restic init --repo $CV_TEX_REPO --password-file $RESTIC_PASSWORD_FILE
[ ! -e "$CV_JS_REPO/config" ] && restic init --repo $CV_JS_REPO --password-file $RESTIC_PASSWORD_FILE

# backup
restic -r $LINUX_REPOSITORY --verbose --password-file $RESTIC_PASSWORD_FILE backup $LINUX_SETUP
restic -r $CV_TEX_REPO --verbose --password-file $RESTIC_PASSWORD_FILE backup $CV_TEX
restic -r $CV_JS_REPO --verbose --password-file $RESTIC_PASSWORD_FILE backup $CV_JS

# restore: latest, 79766175
# restic -r $LINUX_REPOSITORY restore latest --verbose --password-file $RESTIC_PASSWORD_FILE --target $LINUX_SETUP
