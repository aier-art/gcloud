#!/usr/bin/env bash

DIR=$(realpath $0) && DIR=${DIR%/*}
cd $DIR
set -ex

./init.sh
./rust-img.sh &
apt-get install -y docker-compose
./up.sh
wait
