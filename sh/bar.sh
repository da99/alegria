#!/usr/bin/env sh
#
#
set -u -e

PATH="$PATH:$HOME/progs/lemonbar-xft"
exec lemonbar -p  \
	-f "FreeSans:size=32:weight=bold:antialias=true" \
  -f "helv:size=40:weight=bold:antialias=true" \
  -f "helv:size=48:weight=bold:antialias=true" \
  -f "helv:size=54:weight=bold:antialias=true" \
	-g "1920x80+0+0" \
  $@
