#!/usr/bin/env bash

DIR=$(realpath $0) && DIR=${DIR%/*}
cd $DIR

if ! [ -x "$(command -v tmuxp)" ]; then
apt-get install -y tmuxp
fi

session=clip

tmux has-session -t $session 2>/dev/null && exec tmux new-session -A -s $session
exec tmuxp load $DIR/tmux.clip.yml
