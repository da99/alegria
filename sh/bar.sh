#!/usr/bin/env sh
#
#
set -u -e

PATH="$PATH:$HOME/progs/lemonbar-xft"
exec lemonbar -p  \
	-f "helv:size=32:antialias=true" \
  -f "helv:size=48:weight=bold:antialias=true" \
  -f "helv:size=40:weight=bold:antialias=true" \
	-g "1920x80+0+0" \
  $@
