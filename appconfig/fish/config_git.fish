### commons ###
bass source "~/linux-setup/appconfig/shell/commons.sh"

### set ###
set -gx COLORTERM truecolor
set -gx EDITOR nvim
set -gx LANG en_US.UTF-8                           # Adjust this to your language!
set -gx LC_ALL en_US.UTF-8                         # Adjust this to your locale!
set -g fish_key_bindings fish_hybrid_key_bindings

# cursor shapes
set fish_cursor_default     block      blink
set fish_cursor_insert      line       blink
set fish_cursor_replace_one underscore blink
set fish_cursor_visual      block

# true COLOR
set -g fish_term24bit 1

### autocomplete and highlight colors ###
set fish_color_normal brcyan
set fish_color_autosuggestion '#7d7d7d'
set fish_color_command brcyan
set fish_color_error '#ff6c6b'
set fish_color_param brcyan

# Prompt options
set -g theme_display_ruby yes
set -g theme_display_virtualenv yes
set -g theme_display_vagrant no
set -g theme_display_vi yes
set -g theme_display_k8s_context no # yes
set -g theme_display_user yes
set -g theme_display_hostname yes
set -g theme_show_exit_status yes
set -g theme_git_worktree_support no
set -g theme_display_git yes
set -g theme_display_git_dirty yes
set -g theme_display_git_untracked yes
set -g theme_display_git_ahead_verbose yes
set -g theme_display_git_dirty_verbose yes
set -g theme_display_git_master_branch yes
set -g theme_display_date yes
set -g theme_display_cmd_duration yes
set -g theme_powerline_fonts yes
set -g theme_nerd_fonts yes
set -g theme_color_scheme "TokyoNight Night"
set --universal nvm_default_version v20.10.0

### functions ###
function fish_greeting
    random choice "Hi." "Hi"
end

### aliases ###
alias vimdiff="/usr/bin/nvim -d"
alias vi="/usr/bin/nvim"

### abbreviation ###
abbr rm "rm -i"
abbr mkdir "mkdir -p"
abbr rcw "rclone rcd --rc-web-gui"
abbr lll "eza -la --smart-group --tree --level=2 --git --header --icons"

### bind ###
bind --mode insert --sets-mode default jj repaint
bind --mode insert --sets-mode default jk repaint
