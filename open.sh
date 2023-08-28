#!/usr/bin/env bash

# https://console.cloud.google.com/compute/instancesAdd?authuser=1&hl=zh-cn&project=ambient-highway-397200&cloudshell=true
set -ex
zones='northamerica-northeast1-a northamerica-northeast1-b northamerica-northeast1-c us-central1-a us-central1-b us-central1-c us-central1-f us-east1-b us-east1-c us-east1-d us-east4-a us-east4-b us-east4-c us-east5-a us-east5-b us-east5-c us-west1-a us-west1-b us-west1-c us-west2-a us-west2-b us-west2-c us-west3-a us-west3-b us-west3-c us-west4-a us-west4-b us-west4-c europe-north1-a europe-north1-b europe-north1-c europe-west1-b europe-west1-c europe-west1-d europe-west2-a europe-west2-b europe-west2-c europe-west3-a europe-west3-b europe-west3-c europe-west4-a europe-west4-b europe-west4-c europe-west6-a europe-west6-b europe-west6-c asia-east1-a asia-east1-b asia-east1-c asia-east2-a asia-east2-b asia-east2-c asia-northeast1-a asia-northeast1-b asia-northeast1-c asia-northeast2-a asia-northeast2-b asia-northeast2-c asia-northeast3-a asia-northeast3-b asia-northeast3-c asia-south1-a asia-south1-b asia-south1-c asia-south2-a asia-south2-b asia-south2-c asia-southeast1-a asia-southeast1-b asia-southeast1-c australia-southeast1-a australia-southeast1-b australia-southeast1-c southamerica-east1-a southamerica-east1-b southamerica-east1-c southamerica-west1-a southamerica-west1-b southamerica-west1-c'

count=0
machine_types="c2d-standard-4 c2-standard-4"

for machine_type in $machine_types; do
  for zone in $zones; do
    echo $zone
    ((count++)) || true
    gcloud compute instances create instance-$(date +%Y-%m-%d)-$count \
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
      --reservation-affinity=any && exit || true
  done
done
