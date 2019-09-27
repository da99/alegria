#!/usr/bin/env sh
#
#
set -u -e


while sh/is.running ; do
  cd $HOME/apps/alegria

  day_name="$(date +"%a")"
  hour24="$(date +"%-H")"
  min="$(date +"%-M")"

  # Wait a few minutes after downloading updates at 10 am.
  # Then we can reboot.
  if test "$hour24" = "10" && test "$min" = "5" ; then
    sleep 60
    sudo reboot
  else
    sh/sleep.minute
  fi
done
