#!/usr/bin/env bash

DIR=$(realpath $0) && DIR=${DIR%/*}
cd $DIR
set -ex
export DEBIAN_FRONTEND=noninteractive
apt-get install -y git-lfs git

cd ~

if [ ! -d "gcloud" ]; then
  git clone --depth=1 https://github.com/aier-art/gcloud.git
  cd gcloud
else
  cd gcloud
  git pull
fi
cd gcloud

source ./env

./unpack.conf.sh
for script in down.*.sh; do
  if [ -f "$script" ]; then
    bash "$script"
  fi
done

clip_dir=clip-runtime
if [ ! -d "$clip_dir" ]; then
  git clone --depth=1 https://github.com/xxai-art/$clip_dir.git
fi

cd $clip_dir
direnv exec . ./kaggle.sh
