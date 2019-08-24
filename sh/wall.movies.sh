#!/usr/bin/env sh
#
#
set -u -e -x

cd $HOME/apps/alegria

while true ; do
  sleep $(( 60 * 15))
  if sh/is.open ; then
    mpv --fullscreen $HOME/Videos/00-alegria_comm.mp4
  fi
done
