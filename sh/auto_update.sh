#!/usr/bin/env sh
#
#
set -u -e


while sh/is.running ; do
  cd $HOME/apps/alegria
  git pull || :
  sleep $(( 60 * 60 ))
done
