#!/usr/bin/env zsh
#
#
set -u -e -o pipefail

PATH="$PATH:$HOME/progs/lemonbar-xft"
exec lemonbar -p  \
	-f "helv:size=32:antialias=true" \
	-g "1920x80+0+0" \
  $@
