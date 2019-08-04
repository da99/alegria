#!/usr/bin/env zsh
#
#
set -u -e -o pipefail

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

  for photo in $(find "$photo_dir" -maxdepth 1 -type f | grep -Pi '\.(jpg|jpeg|png)$'); do
    feh --fullscreen --borderless "$photo" &
    feh_pid="$!"
    (sleep 5; kill -INT "$feh_pid" ) &
    sleep 4
    echo "exiting"
    exit 0
  done
  # sleep 5
  # pkill -f random_photo_caption || :
  # kill -INT "$feh_pid" || :
done

