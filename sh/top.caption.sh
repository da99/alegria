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

  if sh/is.open && ! sh/is.closing.soon ; then
    msg=""
    if ! pgrep -f top_photo_caption ; then
      msg="$(cat tmp/caption.txt 2>/dev/null || :)"
      if ! test -z "$msg" ; then
        (  echo "%{c}%{T2}$msg" | sh/bar.sh -n "top_photo_caption" -B $blue -F $white || : ) &
      else
        pkill -INT -f top_photo_caption || :
      fi
    fi
  else
    pkill -INT -f top_photo_caption || :
  fi

  sh/sleep.minute
done
