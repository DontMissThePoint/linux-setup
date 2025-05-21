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
		[[ -t 0 ]] && { read -t 10 -n 2 -p $'\e[1;32mInstall qutebrowser? [y/n] (default: '"$default"$')\e[0m\n' resp || resp=$default; }
	fi
	response=$(echo "$resp" | sed -r 's/(.*)$/\1=/')

	if [[ $response =~ ^(y|Y)=$ ]]; then

		toilet Installing qutebrowser -t --filter metal -f smmono12
		cd "$APP_PATH"/../../submodules/qutebrowser
		sudo apt-get -y install --no-install-recommends libsm6 libxext6 ffmpeg ca-certificates python3 python3-venv libgl1 libxkbcommon-x11-0 libfontconfig1 libglib2.0-0 libdbus-1-3 libxcb-cursor0 libxcb-icccm4 libxcb-keysyms1 libxcb-shape0 libnss3 libxcomposite1 libxdamage1 libxrender1 libxrandr2 libxtst6 libxi6 gstreamer1.0-plugins-{bad,base,good,ugly} python3-pyqt5.qtquick python3-pyqt5.qtsql python3-pyqt5.qtopengl asciidoc

		# env
		python3 scripts/mkvenv.py

		#.venv/bin/python3 -m qutebrowser
		mkdir -p ~/.qutebrowser
		rm -fr ~/.qutebrowser/.venv && mv .venv ~/.qutebrowser/

		# wrapper script
		printf '#!/bin/bash\n' >"$APP_PATH"/qutebrowser_env

		echo -e '~/.qutebrowser/.venv/bin/python3 -m qutebrowser "$@"' >>"$APP_PATH"/qutebrowser_env

		chmod +x "$APP_PATH"/qutebrowser_env
		sudo mv -f "$APP_PATH"/qutebrowser_env /bin/qutebrowser
		sudo ln -sf /bin/qutebrowser /usr/local/bin/qutebrowser
		sudo cp "$APP_PATH"/../../submodules/qutebrowser/misc/org.qutebrowser.qutebrowser.desktop /usr/share/applications/org.qutebrowser.qutebrowser.desktop

		# default
		sudo update-alternatives --install /usr/bin/x-www-browser x-www-browser /usr/local/bin/qutebrowser 210

		# flavor
		mkdir -p ~/.config/qutebrowser ~/.local/share/qutebrowser/{greasemonkey,sessions}
		cp -fr "$APP_PATH"/catppuccin ~/.config/qutebrowser/
		ln -sf "$APP_PATH"/config_template.py ~/.config/qutebrowser/config.py
		ln -sf "$APP_PATH"/js.sites ~/.config/qutebrowser/js.sites
		rm -fr "$APP_PATH"/sessions/before* ~/.local/share/qutebrowser/sessions
		ln -sf "$APP_PATH"/sessions ~/.local/share/qutebrowser/sessions

		# userscripts
		cd scripts
		/usr/bin/python3 -m dictcli install "en-US"
		sudo apt install -y libxml2-dev libxslt-dev libjs-pdf qrencode

		cd ~/.config/qutebrowser
		ln -sf "$APP_PATH"/../../submodules/qutebrowser/misc/userscripts ./userscripts
		rm -fr "$GIT_PATH"/linux-setup/submodules/qutebrowser/misc/userscripts/userscripts

		# greasmonkey
		echo "Greasymonkey ..."
		cd ~/.local/share/qutebrowser/greasemonkey
		cat "$APP_PATH"/js.greasyforks | xargs -n1 curl -LO

		# screenshots <space>dp
		mkdir -p ~/Pictures/Screenshots

		toilet Setting up llamaparse -t -f future

		# llama-parse-cli
		pipx install llama-cloud-services

		GREEN='\033[0;32m'
		NC='\033[0m' # No Color
		npm config set strict-ssl=false
		npm install --loglevel=error -g @mozilla/readability \
			write-good cspell bash-language-server \
			jsonrepair jsdom qutejs punycode
		echo -e "${GREEN}llama-parse --help${NC}to get started."

		break
	elif [[ $response =~ ^(n|N)=$ ]]; then
		break
	else
		echo " What? \"$resp\" is not a correct answer. Try y+Enter."
	fi
done
