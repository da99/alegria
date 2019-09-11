#!/usr/bin/env zsh
#
#
set -u -e -o pipefail


if ! test "$USER" = "pi" ; then
  set -x
fi

cd $HOME/apps/alegria
mkdir -p tmp

killall lemonbar || :
killall mpv || :
killall smplayer || :
killall vlc || :

# Minimize any windows.
for x in $(wmctrl -l | cut -d' ' -f1); do
  xdotool windowminimize "$x" || :
done


# Auto-update:
( sh/auto_update.sh || : ) &

# Get the mouse out of the way:
( sh/mouse.move.sh || : ) &

# Movies:
# ( sh/wall.movies.sh || : ) &


# TOP CAPTION:
# ( sh/top.caption.sh || : ) &

# Middle Caption:
( sh/middle.caption.sh || : ) &

# BOTTOM CAPTION:
blue="#132492"
white="#ffffff"
( sh/bottom.caption.sh | sh/bar.sh -f "helv:size=34:weight=bold:antialias=true" -n "bottom_photo_caption" -B $blue -F $white -g "1920x120+0+80" -o -2 || : ) &


# Photo Loop:
while sh/is.running ; do
  seconds="$(date +"%S")"
  minute="$(date +"%M")"

  if sh/is.closed ; then
    if sh/is.opening ; then
      pcmanfm --set-wallpaper $(sh/random.photo $PWD/wall_display/humor) --wallpaper-mode=crop
    else
      pcmanfm --set-wallpaper $PWD/wall_display/closing/closed.jpg --wallpaper-mode=crop
    fi
    sh/sleep.minute
    continue
  fi

  if sh/is.closing.soon ; then
    sh/sleep.minute
    continue
  fi

  for x in $(find wall_display/special -type f -iname "store.jpg" -or iname "stroganoff.jpg" -or -iname "logo.jpg" | tac) ; do
    pkill -INT -f top_photo_caption || :
    rm -f tmp/caption.txt || :
    if sh/is.closing.soon ; then
      continue
    fi
    pcmanfm --set-wallpaper "$PWD/$x" --wallpaper-mode=crop || :
    caption_file="$PWD/$(dirname "$x")/captions/$(basename "$x").txt"
    caption="$(cat "$caption_file" 2>/dev/null || :)"
    if ! test -z "$caption" ; then
      ( echo "%{c}%{T2}$caption" | sh/bar.sh -n "top_photo_caption" -B $blue -F $white || : ) &
    fi
    sh/sleep.minute
    pkill -INT -f top_photo_caption || :
  done

done # while

