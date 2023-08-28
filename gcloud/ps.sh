#!/usr/bin/env bash
[ "$UID" -eq 0 ] || exec sudo "$0" "$@"

DIR=$(realpath $0) && DIR=${DIR%/*}
set -ex

docker-compose ps
