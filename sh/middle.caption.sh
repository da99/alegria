#!/usr/bin/env zsh
#
#
set -u -e -o pipefail -x

cd $HOME/apps/alegria

while true ; do

  if sh/is.opening ; then
    ( echo "%{c}Alegria has not opened yet." | ./bar.sh -n middle_bar_caption -g "1920x80+0+$((1080/2 - 40))" -B "#AC0000" -F "#ffffff" ) &
    while sh/is.opening ; do
      sh/sleep.minute
    done
    pkill -f middle_bar_caption || :
    continue
  fi

  if sh/is.closing.soon ; then
    ( echo "%{c}Alegria is closing soon." | ./bar.sh -n middle_bar_caption -g "1920x80+0+$((1080/2 - 40))" -B "#FFCD30" -F "#AC0000" ) &
    while sh/is.closing.soon ; do
      sh/sleep.minute
    done
    pkill -f middle_bar_caption || :
    continue
  fi

  if sh/is.closed ; then
    ( echo "%{c}Alegria is closed. No more orders." | ./bar.sh -n middle_bar_caption -g "1920x80+0+$((1080/2 - 40))" -B "#AC0000" -F "#ffffff" ) &
    while sh/is.closed ; do
      sh/sleep.minute
    done
    pkill -f middle_bar_caption || :
    continue
  fi

  sh/sleep.minute
done # while
