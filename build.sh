#! /usr/bin/env bash

cargo build --release 2>&1
if [[ $(id -u) == 0 ]]; then
  cp target/release/swell /usr/local/bin/swell
else
  sudo cp target/release/swell /usr/local/bin/swell
fi
