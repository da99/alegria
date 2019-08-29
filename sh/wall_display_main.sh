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

top_msg="%{c}Follow us on Facebook: AlegriaGrill. We're also on Instagram: @AlegriaGrillKaty"
blue="#132492"
white="#ffffff"
black="#000000"
orange="#FF5E00"

# Movies
( sh/wall.movies.sh || : ) &

# TOP CAPTION:
( echo $top_msg | sh/bar.sh -n "top_photo_caption" -B $blue -F $white || : ) &

# Middle Caption:
( sh/middle.caption.sh || : ) &

# BOTTOM CAPTION:
( sh/bottom.caption.sh | sh/bar.sh -f "helv:size=34:weight=bold:antialias=true" -n "bottom_photo_caption" -B $blue -F $white -b || : ) &


# Photo Loop:
while sh/is.running ; do
  seconds="$(date +"%S")"
  minute="$(date +"%M")"

  if ! sh/is.open ; then
    pcmanfm --set-wallpaper $PWD/humor/closed.jpg --wallpaper-mode=crop
    sh/sleep.minute
    continue
  fi

  for x in $(find wall_display/special -type f -iname "*.jpg" -or -iname "*.png" | sort) ; do
    pcmanfm --set-wallpaper $PWD/$x --wallpaper-mode=crop
    sleep 20
  done

done # while

