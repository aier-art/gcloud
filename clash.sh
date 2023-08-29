#!/usr/bin/env bash

DIR=$(realpath $0) && DIR=${DIR%/*}
cd $DIR
set -ex

cd gcloud
if [ ! -s "ops/soft" ]; then
  mkdir -p ops
  cd ops
  git clone --depth=1 https://github.com/wactax/ops.soft.git soft
else
  cd ops
  git pull
fi
soft/clash/supervisor.sh
