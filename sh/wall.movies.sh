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
      ;;
#    "05"|"20"|"35"|"50")
#      mpv --fullscreen $HOME/Videos/grill.01.mp4 || :
#      ;;
    "10"|"25"|"40"|"55")
      mpv --fullscreen $HOME/Videos/grill.02.mp4 || :
      ;;
    "13"|"28"|"43"|"58")
	    true
      ;;
  esac

  sh/sleep.minute
done
