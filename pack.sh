#!/usr/bin/env bash

DIR=$(realpath $0) && DIR=${DIR%/*}
cd $DIR
set -ex

cd ..
TODIR=$DIR/gcloud
cp clip-runtime/env $TODIR
cp clip-runtime/down.*.sh $TODIR

clip_pipe_sh=conn/clip_pipe.sh

sed -i 's/^TASK_PRE_CPU=.*/TASK_PRE_CPU=1/' conf/$clip_pipe_sh

tar cf - conf/conn | zstd >/tmp/conf.tar.zstd
cd conf
git checkout $clip_pipe_sh
cd ..

# 计算当前的sha3哈希值
now_sha=$(shasum -a 512 /tmp/conf.tar.zstd | awk '{print $1}')

sha_txt=$DIR/sha.txt
# 读取先前的sha3哈希值
if [ -f "$sha_txt" ]; then
  sha=$(cat $sha_txt)
else
  sha=""
fi

# 比较当前哈希值与先前的哈希值
if [ "$now_sha" != "$sha" ]; then
  # 哈希值发生了变化
  echo "$now_sha" >$sha_txt
  openssl enc -aes-256-cbc -pbkdf2 -in /tmp/conf.tar.zstd -out $TODIR/conf.tar.zstd.enc -pass env:GCLOUD_TAR_PASSWORD
  rm /tmp/conf.tar.zstd
else
  # 哈希值未发生变化，不需要更新加密文件
  echo "sha same, no need to update the encrypted file."
fi
