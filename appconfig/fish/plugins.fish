#!/bin/fish

# Plugs
echo Installing plugins...
curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source

fisher install vitallium/tokyonight-fish
fish_config theme save "TokyoNight Night"   # Night, Storm, Mooon, Day

fisher install jorgebucaran/fisher
fisher install franciscolourenco/done
fisher install edc/bass
fisher install meaningful-ooo/sponge

fisher install orefalo/grc
fisher install gazorby/fish-abbreviation-tips
fisher install nickeb96/puffer-fish
fisher install jorgebucaran/autopair.fish
fisher install patrickf1/colored_man_pages.fish

fisher install jorgebucaran/nvm.fish
nvm install lts/iron
npm install -g parallel

fisher install IlanCosman/tide@v6
tide configure --auto --style=Classic --prompt_colors='True color' --classic_prompt_color=Dark --show_time='12-hour format' --classic_prompt_separators=Slanted --powerline_prompt_heads=Slanted --powerline_prompt_tails=Slanted --powerline_prompt_style='One line' --prompt_spacing=Sparse --icons='Many icons' --transient=Yes
fish_update_completions
