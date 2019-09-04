#!/usr/bin/env zsh
#
#
set -u -e

cd $HOME/apps/alegria

set -x
for x in $(find wall_display/special -type f -iname "*.jpg" -or -iname "*.png" | shuf) ; do
  pcmanfm --set-wallpaper "$PWD/$x" --wallpaper-mode=crop || :
  if sh/is.closing.soon ; then
    continue
  else
    sleep 10
  fi
done
