#!/bin/sh

sudo apt-get autoremove --purge -y
sudo apt-get autoclean
sudo apt-get clean
sudo dpkg --configure -a
sudo journalctl --rotate
sudo journalctl --vacuum-time=1s
sudo rm -rf ~/var/cache/apt/
rm -rf ~/.cache/*

echo "\e[1;32m\nSystem cleanup done.\n"
