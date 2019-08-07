#!/usr/bin/env zsh
#
#
set -u -e -o pipefail

for x in facebook instagram yelp ; do
  cd /apps/alegria/wall_display/$x
  for photo in $(find . -type f -iname '*.jp*g'); do
    echo " (Posted by Alegria customers on ${x}.)  " > "captions/${photo}.txt"
    echo "Created: ${photo}.txt"
  done
done
