#!/usr/bin/env sh
#
#
set -u -e


while sh/is.running ; do
  cd $HOME/apps/alegria
  git pull || :
  sh/sleep.hour
done
