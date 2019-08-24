#!/usr/bin/env zsh
#
#
set -u -e -o pipefail

echo -n "Wall display is starting. Please wait"
sleep 1; echo -n .
sleep 1; echo -n .
sleep 1; echo -n .
sleep 1; echo .


cd /home/pi/apps/alegria
git pull || :


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
( echo $top_msg | sh/bar.sh -n "top_photo_caption" -B $blue -F $white || : ) &

# Middle Caption:
( sh/middle.caption.sh || : ) &

# BOTTOM CAPTION:
( sh/bottom.caption.sh | sh/bar.sh -n "bottom_photo_caption" -B $blue -F $white -b || : ) &


# Photo Loop:
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



