#!/usr/bin/env sh
#
#
set -u -e -x

cd $HOME/apps/alegria

while sh/is.running ; do
  sh/sleep.minute
  if sh/is.open && ! sh/is.closing.soon ; then
    mpv --fullscreen $HOME/Videos/00-alegria_comm.mp4
  fi

  sleep $(( 60 * 15 ))
done
