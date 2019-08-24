#!/usr/bin/env zsh
#
#
set -u -e -o pipefail -x

killall lemonbar || :
killall mpv || :
killall smplayer || :
killall vlc || :

rm -f /tmp/quit


cd $HOME/apps/alegria
git pull || :

# Minimize any windows.
for x in $(wmctrl -l | cut -d' ' -f1); do
  xdotool windowminimize "$x" || :
done

top_msg="%{c}Follow us on Facebook: AlegriaGrill. We're also on Instagram: @AlegriaGrillKaty"
blue="#132492"
white="#ffffff"
black="#000000"
orange="#FF5E00"


# TOP CAPTION:
( echo $top_msg | ./bar.sh -n "top_photo_caption" -B $blue -F $white || : ) &

# Middle Caption:
( ./middle.caption.sh || : ) &

# BOTTOM CAPTION:
( ./bottom.caption.sh | ./bar.sh -n "bottom_photo_caption" -B $blue -F $white -b || : ) &


# Photo Loop:
while true ; do
  seconds="$(date +"%S")"

  if sh/is.opening ; then
    pcmanfm --set-wallpaper $PWD/humor/flute.jpg --wallpaper-mode=crop
    sleep $(( 60 - $seconds )) || sleep 5
    continue
  fi

  if sh/is.closed ; then
    pcmanfm --set-wallpaper $PWD/humor/weekend.jpg --wallpaper-mode=crop
    sleep $(( 60 - $seconds )) || sleep 5
    continue
  fi

  for x in $(find wall_display/special -type f -iname "*.jpg" -or -iname "*.png") ; do
    pcmanfm --set-wallpaper $PWD/$x --wallpaper-mode=crop
    sleep 30
  done

  case $(date +"%M") in
    5|15|25|35|45|55)
      mpv --fullscreen $HOME/Videos/00-alegria_comm.mp4
      ;;
  esac
done # while



