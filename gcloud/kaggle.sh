#!/usr/bin/env bash

DIR=$(realpath $0) && DIR=${DIR%/*}
cd $DIR
set -ex

source ./env

./unpack.conf.sh

curl --connect-timeout 2 -m 4 -s https://t.co >/dev/null || export GFW=1
[ $GFW ] && ./clash.sh


clip_dir=clip-runtime
if [ -d "$clip_dir" ]; then
  cd $clip_dir
  git pull
else
  git clone --depth=1 https://github.com/xxai-art/$clip_dir.git
  cd $clip_dir
fi

./kaggle.sh
