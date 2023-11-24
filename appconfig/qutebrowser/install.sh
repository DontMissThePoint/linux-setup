#!/bin/bash

set -e

trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
trap 'echo "$0: \"${last_command}\" command failed with exit code $?"' ERR

# get the path to this script
APP_PATH=`dirname "$0"`
APP_PATH=`( cd "$APP_PATH" && pwd )`

unattended=0
subinstall_params=""
for param in "$@"
do
  echo $param
  if [ $param="--unattended" ]; then
    echo "installing in unattended mode"
    unattended=1
    subinstall_params="--unattended"
  fi
done

var1="18.04"
var2=`lsb_release -r | awk '{ print $2 }'`
[ "$var2" = "$var1" ] && export BEAVER=1

default=y
while true; do
  if [[ "$unattended" == "1" ]]
  then
    resp=$default
  else
    [[ -t 0 ]] && { read -t 10 -n 2 -p $'\e[1;32mInstall qutebrowser? [y/n] (default: '"$default"$')\e[0m\n' resp || resp=$default ; }
  fi
  response=`echo $resp | sed -r 's/(.*)$/\1=/'`

  if [[ $response =~ ^(y|Y)=$ ]]
  then

    toilet Installing qutebrowser
    cd $APP_PATH/../../submodules/qutebrowser
    sudo apt-get -y install --no-install-recommends libsm6 libxext6 ffmpeg libgl1-mesa-glx git ca-certificates python3 python3-venv libgl1 libxkbcommon-x11-0 libegl1-mesa libfontconfig1 libglib2.0-0 libdbus-1-3 libxcb-cursor0 libxcb-icccm4 libxcb-keysyms1 libxcb-shape0 libnss3 libxcomposite1 libxdamage1 libxrender1 libxrandr2 libxtst6 libxi6 libasound2 gstreamer1.0-plugins-{bad,base,good,ugly}

    /usr/bin/python3 -m pip install asciidoc
    /usr/bin/python3 scripts/mkvenv.py --pyqt-version 6.4
    
    #.venv/bin/python3 -m qutebrowser
    rm -fr ${APP_PATH}/.venv && mv .venv ${APP_PATH}/
    
    # Wrapper script
    printf '#!/bin/bash\n' > $APP_PATH/qutebrowser_env

    echo -e '$GIT_PATH/linux-setup/appconfig/qutebrowser/.venv/bin/python3 -m qutebrowser "$@"' >> ${APP_PATH}/qutebrowser_env

    chmod +x ${APP_PATH}/qutebrowser_env
    sudo cp ${APP_PATH}/qutebrowser_env /bin/qutebrowser
    sudo ln -sf /bin/qutebrowser /usr/local/bin/qutebrowser

    # Mocha flavor
    mkdir -p ~/.config/qutebrowser ~/.local/share/qutebrowser/sessions
    cp -fr $APP_PATH/catppuccin ~/.config/qutebrowser/
    ln -sf $APP_PATH/config_template.py ~/.config/qutebrowser/config.py
    ln -sf $APP_PATH/sessions ~/.local/share/qutebrowser/

    break
  elif [[ $response =~ ^(n|N)=$ ]]
  then
    break
  else
    echo " What? \"$resp\" is not a correct answer. Try y+Enter."
  fi
done
