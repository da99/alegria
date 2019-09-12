#!/usr/bin/env zsh
#
#
set -u -e -o pipefail

cd $HOME/apps/alegria

while sh/is.running ; do

  day_name="$(date +"%a")"
  hour="$(date +"%I")"
  hour24="$(date +"%H")"
  min="$(date +"%M")"
  seconds="$(date +"%S")"

  public_time="$(date +"%I:%M:%S %p")"

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

  if test "$hour24" -eq 10 ; then
    echo "%{c}%{T4}$public_time $day_name ($((60 - $min)) mins. to opening.)"
  else
    if test "$hour24" -lt 11 ; then
      echo "%{c}%{T4}$public_time $day_name (We are still closed.)"
    else
      if test $min -gt 30 && test $min -lt 59 && test $((closing_hour - 1)) -eq $hour ; then
        echo "%{c}%{T4}$public_time (We close in $((60 - $min)) mins)"
      else
        echo "%{c}%{T4}${public_time} $day_name (Closing: $closing_hour PM)"
      fi
    fi
  fi

  sleep 1
done
