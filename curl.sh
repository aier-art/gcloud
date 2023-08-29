#!/usr/bin/env bash

DIR=$(realpath $0) && DIR=${DIR%/*}
cd $DIR
set -ex
export DEBIAN_FRONTEND=noninteractive

apt-get install -y git-lfs git curl

curl --connect-timeout 2 -m 4 -s https://t.co >/dev/null || GFW=1

[ $GFW ] &&
  git config --global url."https://ghproxy.com/https://github.com".insteadOf "https://github.com"

cd ~

if [ ! -d "gcloud" ]; then
  git clone --depth=1 https://github.com/aier-art/gcloud.git
  cd gcloud
else
  cd gcloud
  git pull
fi

./all.sh >/tmp/all.log 2>&1
