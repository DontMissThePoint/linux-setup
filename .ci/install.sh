#!/bin/bash

set -e

distro=$(lsb_release -r | awk '{ print $2 }')
[ "$distro" = "24.04" ] && ROS_DISTRO="jazzy"

sudo apt-get -y install git

echo "running the main install.sh"

./install.sh --unattended

echo "install part ended"
