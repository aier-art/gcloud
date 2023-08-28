#!/usr/bin/env bash

DIR=$(realpath $0) && DIR=${DIR%/*}
cd $DIR
set -ex

source ./env

./unpack.conf.sh
for script in down.*.sh; do
  if [ -f "$script" ]; then
    bash "$script"
  fi
done

clip_dir=clip-runtime
if [ -d "$clip_dir" ]; then
  cd $clip_dir
  git pull
else
  git clone --depth=1 https://github.com/xxai-art/$clip_dir.git
  cd $clip_dir
fi

direnv exec . ./kaggle.sh
