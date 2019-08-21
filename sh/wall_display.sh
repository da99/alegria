#!/usr/bin/env zsh
#
#
set -u -e -o pipefail -x

cd $(dirname "$(realpath "$0")")


killall lemonbar || :
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

for x in $(find ./special -type f -iname "*.jpg" -or -iname "*.png") ; do
  caption="$(cat $(dirname "$x")/captions/$(basename "$x").txt || :)"
  if ! test -z "$caption" ; then
    ( echo "%{c}$caption" | lemonbar -p -n "random_photo_caption" \
      -f "helv:size=16:antialias=true" \
      -g "1920x40+0+0" \
      -B "#132492" \
      -F "#ffffff"
          ) &
    sleep 10
    pkill -INT -f random_photo_caption
  fi
done
exit 0

(
feh \
  -K captions \
  -r $PWD/special  \
  -C /usr/share/fonts/truetype/liberation2 \
  -e LiberationSerif-Regular/32           \
  --draw-tinted             \
  -D 15                      \
  --fullscreen                \
  -x                           \
  --scale-down                  \
  --auto-zoom || :
  ) &
  sleep 10m
  (
cd $HOME/Videos
mpv --fullscreen main.m3u
) &
killall feh || :


exit 0


photo_dir="$(dirname "$(realpath "$0")")"

function end_all {
  pkill -f random_photo_caption || :
}

trap end_all EXIT

end_all

for caption in $(find "$photo_dir" -maxdepth 2 -type f -iname "caption.txt") ; do
  photo_dir="$(dirname "$caption")"
  caption_content="$(cat "$caption")"
  (
    echo "%{c}$caption_content" | lemonbar -p -n "random_photo_caption" \
      -f "helv:size=16:antialias=true" \
      -g "1920x40+0+0" \
      -B "#132492" \
      -F "#ffffff"
  ) &
  lemon_pid="$!"

  for photo in $(find "$photo_dir" -maxdepth 1 -type f | grep -Pi '\.(jpg|jpeg|png)$' | sort); do
    feh --scale-down --auto-zoom -g "1900x1080" --borderless "$photo" &
    feh_pid="$!"
    (sleep 6; kill -INT "$feh_pid" || :) &
    sleep 4
  done
  (sleep 2; kill -INT "$lemon_pid" || :) &
  # sleep 5
  # pkill -f random_photo_caption || :
  # kill -INT "$feh_pid" || :
done

