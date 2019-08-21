#!/usr/bin/env zsh
#
#
set -u -e -o pipefail -x

cd $(dirname "$(realpath "$0")")


killall lemonbar || :
xset s 6000 6000 6000 || :
killall mpv || :
killall smplayer || :
killall vlc || :

# Minimize any windows.
for x in $(wmctrl -l | cut -d' ' -f1); do
  xdotool windowminimize "$x" || :
done

top_msg="%{c}Follow us on Facebook. We're also on Instagram: @AlegriaGrillKaty"
blue="#132492"
white="#ffffff"
black="#000000"
orange="#FF5E00"

set -x
(
echo "%{c}Follow us on Facebook: AlegriaGrill. We're also on Instagram: @AlegriaGrillKaty" | $HOME/progs/lemonbar-xft/lemonbar -p -n "random_photo_caption" \
	-f "helv:size=28:antialias=true" \
	-g "1920x80+0+0" \
	-B "#132492" \
	-F "#ffffff" || :
) &

# TOP CAPTION:
( echo $top_msg | ./bar -n "top_photo_caption" -B $blue -F $white || : ) &

# Middle Caption:
( ./middle.caption.sh || : ) &

# BOTTOM CAPTION:
( ./bottom.caption.sh | lemonbar -n "bottom_photo_caption" -B $blue -F $black -b || : ) &


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



