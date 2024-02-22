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

fisher install IlanCosman/tide@v6
tide configure --auto --style=Rainbow --prompt_colors='True color' --show_time='24-hour format' --rainbow_prompt_separators=Vertical --powerline_prompt_heads=Round --powerline_prompt_tails=Flat --powerline_prompt_style='Two lines, character' --prompt_connection=Disconnected --powerline_right_prompt_frame=No --prompt_spacing=Compact --icons='Few icons' --transient=Yes
fish_update_completions
