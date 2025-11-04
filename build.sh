#! /usr/bin/env bash

swift build -c release
sudo cp $(swift build -c release --show-bin-path)/swell /usr/local/bin/swell
