#!/usr/bin/env zsh
#
#
set -u -e -o pipefail -x

cd $HOME/apps/alegria

while sh/is.running ; do

  if sh/is.opening ; then
    ( echo "%{c}%{T2}Alegria has not opened yet." | sh/bar.sh \
      -n middle_bar_caption \
      -g "1920x150+0+$((1080/2 - 75))" \
      -B "#AC0000" -F "#ffffff" ) &
    while sh/is.opening ; do
      sh/sleep.minute
    done
    pkill -f middle_bar_caption || :
    continue
  fi

  if sh/is.closing.soon ; then
    ( echo "%{c}%{T2}Alegria is closing soon." | sh/bar.sh \
      -n middle_bar_caption \
      -B "#FFCD30" \
      -F "#AC0000"
    ) &
    while sh/is.closing.soon ; do
      sh/sleep.minute
    done
    pkill -f middle_bar_caption || :
    continue
  fi

  if sh/is.closed ; then
    ( echo "%{c}%{T2}Alegria is closed. No more orders." | sh/bar.sh -n middle_bar_caption -g "1920x80+0+$((1080/2 - 40))" -B "#AC0000" -F "#ffffff" ) &
    while sh/is.closed ; do
      sh/sleep.minute
    done
    pkill -f middle_bar_caption || :
    continue
  fi

  sh/sleep.minute
done # while
