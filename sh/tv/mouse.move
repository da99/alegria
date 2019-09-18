#!/usr/bin/env zsh
#
#
set -u -e

cd $HOME/apps/alegria

while sh/is.running ; do
  xdotool mousemove 1980 1080 || :
  sh/sleep.minute
  sleep $(( 60 * 5 ))
done

