#! /usr/bin/env bash

swift build -c release 2>&1 | grep -v "no version information available"
if [[ $(id -u) == 0 ]]; then
  cp $(swift build -c release --show-bin-path 2>&1 | grep -v "no version information available")/swell /usr/local/bin/swell
else
  sudo cp $(swift build -c release --show-bin-path 2>&1 | grep -v "no version information available")/swell /usr/local/bin/swell
fi
