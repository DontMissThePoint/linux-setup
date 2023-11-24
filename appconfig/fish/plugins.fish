#!/bin/fish

# Plugs
echo Installing plugins...
curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source

fisher install jorgebucaran/fisher
fisher install edc/bass
fisher install meaningful-ooo/sponge

fisher install jorgebucaran/nvm.fish
fisher install vitallium/tokyonight-fish
fish_config theme save "TokyoNight Night" # Night, Storm, Mooon, Day
fish_update_completions

# npm
nvm install lts
npm install -g parallel
