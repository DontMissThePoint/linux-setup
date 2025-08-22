#!/bin/bash

# linux-setup
repo="${GIT_PATH:-$HOME}/linux-setup"

# Send notification
notify_fail() {
    title="❌ Submodule update failed"
    body="$1"
    notify-send -u critical "$title" "$body"
}

# Sync
update_submodules() {
    echo "Starting submodule update in $repo ..."
    git -C "$repo" submodule update --init --recursive

    echo "Checking for updates ..."
    git -C "$repo" submodule foreach '

      ts=$(date +'\''%b %d %H:%M:%S'\'')
      branch=$(git symbolic-ref --quiet --short refs/remotes/origin/HEAD 2>/dev/null | sed "s@^origin/@@")
      [ -z "$branch" ] && branch=$(git for-each-ref --format="%(refname:short)" refs/heads/{main,master} | head -n1)

      if [ -n "$branch" ]; then
        git checkout "$branch"
        if git pull --ff-only origin "$branch"; then
          echo "$ts [$name] $branch"
        else
          echo "$ts [$name]  Failed to fast-forward $branch"
          notify-send -u critical "ⓘ Submodule warnings" "[$name] Failed to fast-forward branch $branch"
        fi
      else
        echo "$ts [$name] ❌ No main/master branch found"
        notify-send -u critical "❌ Submodule update failed" "[$name] No main/master branch found"
      fi
    '

    echo "Done."
}

update_submodules
