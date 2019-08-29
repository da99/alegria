#!/usr/bin/env sh
#
#
set -u -e


while pgrep -f wall_display.sh ; then
  cd $HOME/apps/alegria
  git pull || :
  sleep $(( 60 * 60 ))
fi
