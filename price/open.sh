#!/usr/bin/env bash

DIR=$(realpath $0) && DIR=${DIR%/*}
cd $DIR
set -ex

zone=$1
machine_type=$2

name=instance-$(date +%Y-%m-%d)-price-$3
gcloud compute instances create $name \
  --project=ambient-highway-397200 \
  --zone=$zone \
  --machine-type=$machine_type \
  --network-interface=network-tier=PREMIUM,stack-type=IPV4_ONLY,subnet=default \
  --no-restart-on-failure \
  --maintenance-policy=TERMINATE \
  --provisioning-model=SPOT \
  --instance-termination-action=STOP \
  --service-account=942984209609-compute@developer.gserviceaccount.com \
  --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append \
  --create-disk=auto-delete=yes,boot=yes,device-name=instance-20,image=projects/ubuntu-os-cloud/global/images/ubuntu-2304-lunar-amd64-v20230810,mode=rw,size=19,type=projects/ambient-highway-397200/zones/$zone/diskTypes/pd-standard \
  --no-shielded-secure-boot \
  --shielded-vtpm \
  --shielded-integrity-monitoring \
  --labels=goog-ec-src=vm_add-gcloud \
  --metadata-from-file startup-script=$DIR/init.sh \
  --reservation-affinity=any && echo "$name opened"
