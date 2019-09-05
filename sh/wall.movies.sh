#!/usr/bin/env sh
#
#
set -u -e -x

cd $HOME/apps/alegria

while sh/is.running ; do
  if sh/is.closed || sh/is.closing.soon ; then
    sh/sleep.minute
    continue
  fi

  min="$(date +"%M")"
  case "$min" in
    "00"|"15"|"30"|"45")
        mpv --fullscreen $HOME/Videos/00-alegria_comm.mp4 || :
    "05"|"38")
        mpv --fullscreen $HOME/Videos/strog.cooking.mp4 || :
    ;;
  esac

  sh/sleep.minute
done
