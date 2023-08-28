#!/usr/bin/env bash

cat <<EOF
apt-get update
apt-get install -y curl
export GCLOUD_TAR_PASSWORD=$GCLOUD_TAR_PASSWORD
curl -sSL https://raw.githubusercontent.com/aier-art/gcloud/main/curl.sh | bash
EOF
