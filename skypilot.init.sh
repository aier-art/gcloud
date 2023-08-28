#!/usr/bin/env bash

DIR=$(realpath $0) && DIR=${DIR%/*}
cd $DIR
set -ex

pip install "skypilot[gcp]"
pip install google-api-python-client

if ! [ -x "$(command -v gcloud)" ]; then
  apt-get install -y apt-transport-https ca-certificates gnupg curl
  echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
  curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
  apt-get update && apt-get -y install google-cloud-cli
fi

gcloud init
gcloud auth application-default login
sky check
exec sky spot launch --disk-size 50 --memory 16 ./clip.yaml
