#!/usr/bin/env sh
#
#
set -u -e

cd $HOME/apps/alegria

echo -n "Wall display is starting. Downloading updates..."
git pull || :

export WALL_PID="$$"
sh/wall_display_main.sh


