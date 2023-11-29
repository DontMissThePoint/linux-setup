#!/bin/fish

# Plugs
echo Installing plugins...
curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source

fisher install jorgebucaran/fisher
fisher install franciscolourenco/done
fisher install edc/bass
fisher install meaningful-ooo/sponge

fisher install orefalo/grc
fisher install gazorby/fish-abbreviation-tips
fisher install nickeb96/puffer-fish
fisher install jorgebucaran/autopair.fish

fisher install jorgebucaran/nvm.fish
fisher install vitallium/tokyonight-fish
fish_config theme save "TokyoNight Night" # Night, Storm, Mooon, Day
fish_update_completions

# npm
nvm install lts/iron
npm install -g parallel
