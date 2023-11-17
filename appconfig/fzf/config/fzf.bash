# Setup fzf
# ---------
if [[ ! "$PATH" == */home/linux-setup/submodules/fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}${HOME}/linux-setup/submodules/fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "${HOME}/linux-setup/submodules/fzf/shell/completion.bash" 2> /dev/null

# Key bindings
# ------------
# source "${HOME}/linux-setup/submodules/fzf/shell/key-bindings.bash"
