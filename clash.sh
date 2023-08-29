#!/usr/bin/env bash

DIR=$(realpath $0) && DIR=${DIR%/*}
cd $DIR
set -ex

cd gcloud
if [ ! -s "soft" ]; then
git clone --depth=1 https://github.com/wactax/ops.soft.git soft
fi

