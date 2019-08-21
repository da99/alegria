#!/usr/bin/env zsh
#
#
set -u -e -o pipefail -x

cd $(dirname "$(realpath "$0")")

while true ; do

  day_name="$(date +"%a")"
  hour="$(date +"%I")"
  hour24="$(date +"%H")"
  min="$(date +"%M")"
  second="$(date +"%S")"

  public_time="$(date +"%I:%M %p")"

  case $day_name in
    Sun)
      closing_hour="4"
      ;;
    Mon)
      closing_hour="3"
      ;;
    Fri|Sat)
      closing_hour="9"
      ;;
    *)
      closing_hour="8"
      ;;
  esac
  closing_hour24="$((12 + $closing_hour))"


  if test $hour24 -lt 11; then
    ( echo "%{c}Alegria has not opened yet." | ./bar.sh -n middle_bar_caption -g "1920x80+0+$((1080/2 - 40))" -B "#AC0000" -F "#ffffff" ) &
    sleep $(( ((11 - $hour24) * 60) + ((60 - $min) * 60)  )) || sleep 1
    pkill -f middle_bar_caption || :
    continue
  fi

  is_closed=""

  if test $min -eq 59 && test $((closing_hour24 - 1)) -eq $hour24 ; then
    is_closed="yes"
  fi

  if test $hour24 -ge $closing_hour24 || test $hour24 -lt 11; then
    is_closed="yes"
  fi

  if ! test -z $is_closed ; then
    ( echo "%{c}Alegria is closed. No more orders." | ./bar.sh -n middle_bar_caption -g "1920x80+0+$((1080/2 - 40))" -B "#AC0000" -F "#ffffff" ) &
    sleep $((60 * 60))
    pkill -f middle_bar_caption || :
  fi

  sleep $((60 - $second)) || sleep 1
done # while
