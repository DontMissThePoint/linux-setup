#!/bin/bash

set -e

trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
trap 'echo "$0: \"${last_command}\" command failed with exit code $?"' ERR

# get the path to this script
APP_PATH=$(dirname "$0")
APP_PATH=$( (cd "$APP_PATH" && pwd))

unattended=0
subinstall_params=""
for param in "$@"; do
    echo "$param"
    if [ "$param=--unattended" ]; then
        echo "installing in unattended mode"
        unattended=1
        subinstall_params="--unattended"
    fi
done

default=y
while true; do
    if [[ "$unattended" == "1" ]]; then
        resp=$default
    else
			[[ -t 0 ]] && { read -t 5 -n 2 -p $'\e[1;32mInstall visidata (sqlit, rbql, calcpy)? [y/n] (default: '"$default"$')\e[0m\n' resp || resp=$default; }
    fi
    response=$(echo "$resp" | sed -r 's/(.*)$/\1=/')

    if [[ $response =~ ^(y|Y)=$ ]]; then

        toilet Installing visidata -t --filter metal -f smmono12

				sudo apt install -y python3-lxml python3-pandas python3-h5py python3-yaml python3-requests python3-tz python3-virtualenv python3-genshi python-lxml-doc img2pdf datamash pdftk visidata

        # packages
        /usr/bin/python3 -m pip install --user --break-system-packages -U rich-cli \
            datapackage pypng pdfminer.six ptpython pytz PyYAML lxml \
            xlrd openpyxl pyxlsb h5py pyreadstat requests IPython \
            virtualenv tomli tabulate odfpy rbql

        # pipx
        /home/linuxbrew/.linuxbrew/bin/pipx install posting sqlit-tui

        toilet Settingup zathura -t -f future

        # zathura
        sudo apt install -y zathura mupdf mupdf-tools faketime xsltproc htmldoc libreoffice pandoc pdf-presenter-console

        mkdir -p ~/.visidata ~/.config/zathura
        cp -f "$APP_PATH"/dotvisidata/* ~/.visidata
        pv "$APP_PATH"/visidatarc >~/.visidatarc

        toilet Settingup calcpy -t -f future

        # Green: #b9edcd background: #384f45 links: #0088cc
        echo "Include... IPython, SymPy"

        # calcpy
        /home/linuxbrew/.linuxbrew/bin/pipx install git+https://github.com/idanpa/calcpy

        break
    elif [[ $response =~ ^(n|N)=$ ]]; then break
    else
        echo " What? \"$resp\" is not a correct answer. Try y+Enter."
    fi
done
