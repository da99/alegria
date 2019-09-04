#!/usr/bin/env zsh
#
#
set -u -e -o pipefail

cd $HOME/apps/alegria

blue="#132492"
white="#ffffff"
black="#000000"
orange="#FF5E00"
while sh/is.running ; do

  if sh/is.open && ! sh/is.closing.soon ; then
    if ! pgrep -f top_photo_caption ; then
      top_msg="%{c}Follow us on Facebook: AlegriaGrill. We're also on Instagram: @AlegriaGrillKaty"
      ( echo $top_msg | sh/bar.sh -n "top_photo_caption" -B $blue -F $white || : ) &
    fi
  else
    pkill -INT -f top_photo_caption || :
  fi
  sh/sleep.minute
done
