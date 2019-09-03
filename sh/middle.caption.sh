#!/usr/bin/env zsh
#
#
set -u -e -o pipefail -x

cd $HOME/apps/alegria

while sh/is.running ; do

  if sh/is.opening ; then
    ( echo "%{c}%{T3}Alegria has not opened yet." | sh/bar.sh \
      -n middle_bar_caption \
      -g "1920x250+0+$((1080/2 - 125))" \
      -B "#AC0000" -F "#ffffff" ) &
    while sh/is.opening ; do
      sh/sleep.minute
    done
    pkill -f middle_bar_caption || :
    continue
  fi

  if sh/is.closing.soon ; then
    ( echo "%{c}%{T3}Alegria is closing soon." | sh/bar.sh \
      -n middle_bar_caption \
      -g "1920x250+0+$((1080/2 - 125))" \
      -B "#FFCD30" \
      -F "#AC0000"
    ) &
    while sh/is.closing.soon ; do
      pcmanfm --set-wallpaper $PWD/wall_display/humor/closing_soon.jpg --wallpaper-mode=crop
      sh/sleep.minute
    done
    pkill -f middle_bar_caption || :
    continue
  fi

  if sh/is.closed ; then
    ( echo "%{c}%{T3}Alegria is closed. No more orders." | sh/bar.sh -n middle_bar_caption -g "1920x250+0+$((1080/2 - 125))" -B "#AC0000" -F "#ffffff" ) &
    while sh/is.closed ; do
      sh/sleep.minute
    done
    pkill -f middle_bar_caption || :
    continue
  fi

  sh/sleep.minute
done # while
