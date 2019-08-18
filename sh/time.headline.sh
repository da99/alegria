#!/usr/bin/env zsh
#
#
set -u -e -o pipefail


while true ; do

  day_name="$(date +"%a")"
  hour="$(date +"%I")"
  min="$(date +"%M")"

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

  if test $min -gt 30 && test $min -lt 59 && test $((closing_hour - 1)) -eq $hour ; then
    echo "%{c}$public_time $day_name (We close in $((60 - $min)) mins)"
  else
    if test $closing_hour -eq $hour || ( test $((closing_hour - 1)) -eq $hour && test "$min" -eq 59) ; then
      echo "%{c}We are closed. To-go orders only."
    else
      echo "%{c}$public_time $day_name (We close at $closing_hour PM)"
    fi
  fi

  sleep 2
done
