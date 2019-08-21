#!/usr/bin/env zsh
#
#
set -u -e -o pipefail -x

cd $(dirname "$(realpath "$0")")/..
git pull || :

cd $(dirname "$(realpath "$0")")


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

set -x

# TOP CAPTION:
( echo $top_msg | ./bar.sh -n "top_photo_caption" -B $blue -F $white || : ) &

# Middle Caption:
( ./middle.caption.sh || : ) &

# BOTTOM CAPTION:
( ./bottom.caption.sh | ./bar.sh -n "bottom_photo_caption" -B $blue -F $white -b || : ) &


# Photo Loop:
set -x
cd ..
while ! test -f /tmp/quit ; do
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



