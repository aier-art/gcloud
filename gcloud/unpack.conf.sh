#!/usr/bin/env bash

DIR=$(realpath $0) && DIR=${DIR%/*}
cd $DIR
set -ex

if ! [ -x "$(command -v zstd)" ]; then
  apt-get install -y zstd
fi
openssl enc -d -aes-256-cbc -pbkdf2 -in conf.tar.zstd.enc -pass env:GCLOUD_TAR_PASSWORD | zstd -d | tar xf -
