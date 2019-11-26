#!/usr/bin/env sh
#
#
set -u -e


while sh/is.running ; do
  sh/sleep.hour
  cd $HOME/apps/alegria
  git pull || :
done
