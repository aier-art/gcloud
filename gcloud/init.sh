#!/usr/bin/env bash

[ "$UID" -eq 0 ] || exec "$0" "$@"
DIR=$(realpath $0) && DIR=${DIR%/*}
cd $DIR
set -ex

swap_status=$(swapon -s)

# 如果没有配置swap
if [[ -z "$swap_status" ]]; then
  # 创建和启用swap
  mkdir -p /swap
  cd /swap
  fallocate -l 8G swapfile
  mkswap swapfile
  swapon swapfile
  # 检查 /etc/fstab 中是否有 /swap/swapfile 条目
  if ! grep -q "/swap/swapfile" /etc/fstab; then
    # 如果没有，则将新的虚拟内存添加到 /etc/fstab
    echo "/swap/swapfile none swap sw 0 0" >>/etc/fstab
  fi
fi

set_to_yes() {
  local config_file="$1"
  shift # 将位置参数向左移动，使得$@包含所有的配置项

  for key in "$@"; do
    # 如果配置项存在，则修改它的值为yes
    # 否则，向文件末尾添加配置项并设置为yes
    if grep -q -E "^\s*${key}\s+" "$config_file"; then
      sed -i "s/^${key}\s.*/${key} yes/" $config_file
    else
      echo "${key} yes" >>"$config_file"
    fi
  done
}

set_to_yes /etc/ssh/sshd_config PermitRootLogin

service sshd restart || true

apt-get update
apt-get install -y curl bash rsync curl
if ! [ -x "$(command -v docker)" ]; then
  curl -fsSL https://get.docker.com | bash -s docker
fi
systemctl start docker
systemctl enable docker

source ./env

for script in down.*.sh; do
  if [ -f "$script" ]; then
    bash "$script"
  fi
done

./unpack.conf.sh
rsync -av ./os/ /
chown -R $USER:$USER ~/.ssh
chmod 600 ~/.ssh/*
