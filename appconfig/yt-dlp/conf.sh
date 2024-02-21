##Variables {{{
# history is on by default it can be set to -> 0 history off, 1: history on
ytfzf_hist=1

# if set to 1 it is on but normally it is off by default. can be turned on using option -l
ytfzf_loop=0

# set the video format
ytfzf_pref="bestvideo[height<=?1080]+bestaudio/best"

# fzf colors are going to be the one from your fzf configuration
ytfzf_enable_fzf_default_opts=1

# sets the video player used by ytfzf (mpv by default), e.g. FZF_PLAYER="devour mpv";
# you can also specify the YTFZF_PLAYER_FORMAT, e.g. YTFZF_PLAYER_FORMAT="devour mpv --ytdl-format="
# fzf_player="mpv"

##scrape 1 video link per channel instead of the default 2
#sub_link_count=1
show_thumbnails=1
##}}}

##Functions {{{
external_menu () {
   #use rofi instead of dmenu
   # rofi -dmenu -width 1500 -p "$1"
   rofi -config "$HOME/.i3/styles/launcher.rasi"
}

mpv_config="-hwdec --autofit-larger=100% --geometry=1080-2-2"

video_player() {
	#this function should not be set as the url_handler as it is part of multimedia_player
	# dep_check "mpv" || die 3 "mpv is not installed\n"
	case "$is_detach" in
		0) mpv $mpv_config --ytdl-format="$video_pref" "$@" ;;
		1) setsid -f mpv --ytdl-format="$video_pref" "$@" > /dev/null 2>&1 ;;
	esac
}
#}}}
