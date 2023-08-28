#!/usr/bin/env bash

DIR=$(realpath $0) && DIR=${DIR%/*}
cd $DIR
set -ex

cat ./env.sh >gcloud/env.sh
exec sky spot launch --disk-size 20 --memory 16 ./clip.yaml
