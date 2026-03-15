#!/bin/bash
set -e

rm -d -r .build
mkdir .build

if [ "$1" = "install" ]; then
    odin build src/ -out:.build/swell -o:speed
    echo "Built swell successfully"
    sudo cp .build/swell /usr/local/bin/
    echo "Installed to /usr/local/bin/swell"
else
    odin build src/ -out:.build/swell -debug -o:none
    echo "Built swell in debug mode"
fi
