#!/usr/bin/env bash

DIR=$(realpath $0) && DIR=${DIR%/*}
cd $DIR
set -ex

cat ./env.sh >gcloud/env.sh

exec sky launch -c clip \
  --disk-size 50 --memory 16 ./clip.yaml
