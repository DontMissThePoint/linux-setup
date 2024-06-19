##Variables {{{
# history is on by default it can be set to -> 0 history off, 1: history on
ytfzf_hist=1

# if set to 1 it is on but normally it is off by default. can be turned on using option -l
ytfzf_loop=0

# set the video format
ytfzf_pref="bestvideo[ext=mp4][height<=1080]+bestaudio[ext=m4a]/best[ext=mp4][height<=1080]"

# fzf colors are going to be the one from your fzf configuration
ytfzf_enable_fzf_default_opts=1

# sets the video player used by ytfzf (mpv by default), e.g. FZF_PLAYER="devour mpv";
# you can also specify the YTFZF_PLAYER_FORMAT, e.g. YTFZF_PLAYER_FORMAT="devour mpv --ytdl-format="
fzf_player="devour mpv"

##scrape 1 video link per channel instead of the default 2
#sub_link_count=1
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
