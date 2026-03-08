#!/bin/bash
set -e

odin build src/ -out:swell -o:speed

echo "Built swell successfully"

if [ "$1" = "install" ]; then
    sudo cp swell /usr/local/bin/swell
    echo "Installed to /usr/local/bin/swell"
fi
