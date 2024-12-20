##Variables {{{
# history is on by default it can be set to -> 0 history off, 1: history on
ytfzf_hist=1

# if set to 1 it is on but normally it is off by default. can be turned on using option -l
ytfzf_loop=0

# set the video format
# ytfzf_pref="bestvideo[ext=mp4][height<=1080]+bestaudio[ext=m4a]/best[ext=mp4][height<=1080]"
ytfzf_pref="bestvideo[height<=?720]+bestaudio/best"

# fzf colors are going to be the one from your fzf configuration
ytfzf_enable_fzf_default_opts=1

# sets the video player used by ytfzf (mpv by default), e.g. FZF_PLAYER="devour mpv";
# you can also specify the YTFZF_PLAYER_FORMAT, e.g. YTFZF_PLAYER_FORMAT="devour mpv --ytdl-format="
fzf_player="devour mpv"

##scrape 1 video link per channel instead of the default 2
sub_link_count=10
show_thumbnails=1
async_thumbnails=1

# use program for displaying thumbnails
load_thumbnail_viewer="catimg-256"
fzf_preview_side="right"

# sort videos (after scraping) by upload date
is_sort=1

# Show notifications when a video is about to be played,
# and other notifications relating to playing videos
notify_playing=1

# specify the path to youtube-dl or a fork of youtube-dl for downloading
ytdlp_path="/usr/bin/yt-dlp"

# whether or not to keep cache after ytfzf exists
keep_cache=0
##}}}

##Misc {{{

#when no search is provided, or -s is given, use this prompt
search_prompt="Search Youtube: "

#useragent when using curl on youtube
useragent="Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/88.0.4324.152 Safari/537.36"

#whether or not to exit when an invalid opt is passed
exit_on_opt_error=1

#the file for storing watch history
history_file="$cache_dir/ytfzf_hst"

#the file for writing the menu option that was chosen
current_file="$cache_dir/ytfzf_cur"

#the folder where thumbnails are cached
thumb_dir="$cache_dir/thumb"

video_info_text() {
	printf "%-${title_len}.${title_len}s\t" "$title"
	printf "%-${channel_len}.${channel_len}s\t" "$channel"
	printf "%-${dur_len}.${dur_len}s\t" "$duration"
	printf "%-${view_len}.${view_len}s\t" "$views"
	printf "%-${date_len}.${date_len}s\t" "$date"
	printf "%-${url_len}.${url_len}s\t" "$shorturl"
	printf "\n"
}

thumbnail_video_info_text () {
         printf "\n${c_cyan}%s" "$title"
         printf "\n${c_blue}Channel      ${c_green}%s" "$channel"
         printf "\n${c_blue}Duration     ${c_yellow}%s" "$duration"
         printf "\n${c_blue}Views        ${c_magenta}%s" "$views"
         printf "\n${c_blue}Date         ${c_cyan}%s" "$date"
}

on_opt_parse () {
    return 0
}
##}}}
