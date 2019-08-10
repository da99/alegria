#!/usr/bin/env zsh
#
#
set -u -e -o pipefail

for x in $(wmctrl -l | cut -d' ' -f1); do
  xdotool windowminimize "$x" || :
done

cd $HOME/apps/alegria/wall_display
for x in $(find ./special -type f -iname "*.jpg" -or -iname "*.png") ; do
  feh --bg-fill  $x
  caption="$(cat $(dirname "$x")/captions/$(basename "$x").txt || :)"
  if ! test -z "$caption" ; then
    ( echo "%{c}$caption" | $HOME/progs/lemonbar-xft/lemonbar -p -n "random_photo_caption" \
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
    echo "%{c}$caption_content" | $HOME/progs/lemonbar-xft/lemonbar -p -n "random_photo_caption" \
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

