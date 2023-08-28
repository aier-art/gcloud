#!/usr/bin/env bash

DIR=$(realpath $0) && DIR=${DIR%/*}
cd $DIR
set -ex

if [ ! -f "lib/model/$MODEL/process/tokenizer.json" ]; then
  mkdir -p lib/model
  cd lib/model
  wget -c $MODEL_URL
  FILE=$(basename $MODEL_URL)
  if [ -x "$(command -v apt-get)" ]; then
    if ! [ -x "$(command -v pbzip2)" ]; then
      apt-get install -y pbzip2
    fi
    if ! [ -x "$(command -v pv)" ]; then
      apt-get install -y pv
    fi
    pv $FILE | pbzip2 -d | tar xf -
  else
    tar xvf $FILE
  fi
  rm $FILE
fi
