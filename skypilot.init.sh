#!/usr/bin/env bash

DIR=$(realpath $0) && DIR=${DIR%/*}
cd $DIR
set -ex

pip install "skypilot[gcp]"
pip install google-api-python-client
gcloud init
gcloud auth application-default login
