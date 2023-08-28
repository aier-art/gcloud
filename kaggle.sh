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
./down.dll.sh
./down.model.sh
git clone --depth=1 https://github.com/xxai-art/clip-runtime.git
cd clip-runtime
direnv exec . ./kaggle.sh


