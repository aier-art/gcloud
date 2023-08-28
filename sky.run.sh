#!/usr/bin/env bash

DIR=$(realpath $0) && DIR=${DIR%/*}
cd $DIR
set -ex

cat ./env.sh >gcloud/env.sh
sky spot launch ./clip.yaml
