#!/usr/bin/env bash

if [ -d flats ]; then
  rm -rf flats
fi

mkdir -p flats

./node_modules/.bin/truffle-flattener contracts/MyConsumer.sol > flats/MyConsumer_flat.sol
