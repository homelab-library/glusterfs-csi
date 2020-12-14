#!/usr/bin/env bash
set -Eeuo pipefail

docker run --rm -it \
    --network host $(docker build -q -f csc.dockerfile .) --endpoint tcp://127.0.0.1:10000 $@
