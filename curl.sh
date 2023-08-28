#!/usr/bin/env bash

DIR=$(realpath $0) && DIR=${DIR%/*}
cd $DIR
set -ex

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
./init.sh
./rust-img.sh &
apt-get install -y docker-compose
./up.sh
wait
