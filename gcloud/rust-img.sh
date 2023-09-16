#!/usr/bin/env bash

DIR=$(realpath $0) && DIR=${DIR%/*}
cd $DIR
set -ex

if [ -d "rust-img" ]; then
  cd rust-img && git pull
else
  git clone --depth=1 https://github.com/xxai-art/rust-img.git
  cd rust-img
fi

./sh/libjxl.sh
./dist.native.sh
rm -rf target
rm -rf ~/.cache
