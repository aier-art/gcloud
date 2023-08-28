#!/usr/bin/env bash

[ "$UID" -eq 0 ] || exec sudo "$0" "$@"
DIR=$(realpath $0) && DIR=${DIR%/*}
set -ex
if [ -z "$1" ]; then
  docker-compose down
else
  docker-compose stop $1
  yes | docker-compose rm $1
fi
