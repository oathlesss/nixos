#!/usr/bin/env fish

if test (count $argv) -eq 1
    set selected $argv[1]
else
    set selected (begin; find ~/repos ~/work -mindepth 1 -maxdepth 1 -type d; echo $HOME/nixos; end | fzf)
end

if test -z "$selected"
    exit 0
end

set selected_name (basename $selected | tr . _)

if test -z "$TMUX"; and not pgrep -x tmux > /dev/null
    tmux new-session -s $selected_name -c $selected
    exit 0
end

if not tmux has-session -t=$selected_name 2>/dev/null
    tmux new-session -ds $selected_name -c $selected
end

if test -z "$TMUX"
    tmux attach -t $selected_name
else
    tmux switch-client -t $selected_name
end
