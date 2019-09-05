#!/usr/bin/env zsh
#
#
set -u -e -o pipefail

if ! test "$USER" = "pi" ; then
  set -x
fi

cd $HOME/apps/alegria

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
( sh/wall.movies.sh || : ) &

# TOP CAPTION:
( sh/top.caption.sh || : ) &

# Middle Caption:
( sh/middle.caption.sh || : ) &

# BOTTOM CAPTION:
blue="#132492"
white="#ffffff"
( sh/bottom.caption.sh | sh/bar.sh -f "helv:size=34:weight=bold:antialias=true" -n "bottom_photo_caption" -B $blue -F $white -b || : ) &


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

  for x in $(find wall_display/special -type f -iname "*.jpg" -or -iname "*.png" | shuf) ; do
    pcmanfm --set-wallpaper "$PWD/$x" --wallpaper-mode=crop || :
    if sh/is.closing.soon ; then
      continue
    else
      sleep 10
    fi
  done

done # while

