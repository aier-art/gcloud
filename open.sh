#!/usr/bin/env bash

# https://console.cloud.google.com/compute/instancesAdd?authuser=1&hl=zh-cn&project=ambient-highway-397200&cloudshell=true
set -e

count=0
machine_types="c2-standard-4 c2d-standard-4"

for machine_type in $machine_types; do
  zones=$(gcloud compute machine-types list --filter="name=('$machine_type')" | tail -n +2 | awk '{print $2}' | sort -r)
  for zone in $zones; do
    ((count++)) || true
    echo -e "\n$count $zone $machine_type"
    name=instance-$(date +%Y-%m-%d)-$count
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
      --reservation-affinity=any && echo "$name opened" && exit || true
  done
done
