#!/usr/bin/env zsh
#
#
set -u -e -o pipefail

cd $HOME/apps/alegria

top_msg="%{c}Fb: @AlegriaGrill. Instagram: @AlegriaGrillKaty. WWW: AlegriaGrill.com"
blue="#132492"
white="#ffffff"
black="#000000"
orange="#FF5E00"

while sh/is.running ; do
  if sh/is.closing.soon || sh/is.closed ; then
    pkill -INT -f top_photo_caption || :
  else
    if ! pgrep -f top_photo_caption ; then
      ( echo $top_msg | sh/bar.sh -n "top_photo_caption" -B $blue -F $white ) &
    fi
  fi
  sh/sleep.minute
done
