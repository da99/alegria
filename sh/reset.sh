#!/usr/bin/env zsh
#
#
set -u -e -o pipefail

set -x

cd /apps/alegria
db_file="data/main.db"

case "$(hostname)" in
  bdrm|v01) true ;;
  *) exit 2 ;;
esac
rm -f "$db_file"
set +x

for x in $(find data/sqlite -maxdepth 1 -type f -name '*.sql' | sort) ; do
  echo "--- $x"
  sqlite3 "$db_file"< $x
done

sqlite3 "$db_file" .dump

