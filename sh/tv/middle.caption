#!/usr/bin/env zsh
#
#
set -u -e -o pipefail -x

cd $HOME/apps/alegria

while sh/is.running ; do

  if sh/is.opening ; then
    ( echo "%{c}%{T3}Alegria has not opened yet." | sh/bar.sh \
      -n middle_bar_caption \
      -g "1920x110+0+40" \
      -B "#AC0000" -F "#ffffff" ) &
    while sh/is.opening ; do
      sh/sleep.minute
    done
    pkill -f middle_bar_caption || :
    continue
  fi

  if sh/is.closing.soon ; then
    ( echo "%{c}%{T4}Alegria is closing soon." | sh/bar.sh \
      -n middle_bar_caption \
      -g "1920x200+0+$((1080/2 - 105))" \
      -B "#FFCD30" \
      -F "#AC0000"
    ) &
    while sh/is.closing.soon ; do
      pcmanfm --set-wallpaper $PWD/wall_display/closing/closing_soon.jpg --wallpaper-mode=crop
      sh/sleep.minute
    done
    pkill -f middle_bar_caption || :
    continue
  fi

  if sh/is.closed ; then
    ( echo "%{c}%{T4}Alegria is closed." | sh/bar.sh -n middle_bar_caption -g "1920x120+0+$((1080/2 - 60))" -B "#AC0000" -F "#ffffff" ) &
    while sh/is.closed && ! sh/is.opening ; do
      sh/sleep.minute
    done
    pkill -f middle_bar_caption || :
    continue
  fi

  sh/sleep.minute
done # while

