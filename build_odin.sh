#!/bin/bash
set -e

rm -d -r .build
mkdir .build
odin build src/ -out:.build/swell -o:speed

echo "Built swell successfully"

if [ "$1" = "install" ]; then
    sudo cp .build/swell /usr/local/bin/
    echo "Installed to /usr/local/bin/swell"
fi
