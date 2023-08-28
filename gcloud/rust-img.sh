#!/usr/bin/env bash

DIR=$(realpath $0) && DIR=${DIR%/*}
cd $DIR
set -ex

git clone --depth=1 https://github.com/xxai-art/rust-img.git
cd rust-img
./sh/libjxl.sh
./dist.native.sh
