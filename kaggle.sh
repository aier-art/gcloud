#!/usr/bin/env bash

DIR=$(realpath $0) && DIR=${DIR%/*}
cd $DIR
set -ex
export DEBIAN_FRONTEND=noninteractive
apt-get install -y git-lfs git

curl --connect-timeout 2 -m 4 -s https://t.co >/dev/null || GFW=1

[ $GFW ] && rsync -av ./gfw/ /

cd ~

if [ ! -d "gcloud" ]; then
  git clone --depth=1 https://github.com/aier-art/gcloud.git
  cd gcloud
else
  cd gcloud
  git pull
fi

exec ./gcloud/kaggle.sh
