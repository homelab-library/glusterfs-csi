#!/usr/bin/env bash
set -Eeuo pipefail

docker build -f build.dockerfile .

docker run --rm -it --network host -v $PWD/driver:/go/src/gluster \
    --privileged -e LD_LIBRARY_PATH=/usr/local/lib \
    --name csi-dev \
    $(docker build -q -f build.dockerfile .) \
    go run . --endpoint tcp://127.0.0.1:10000 --nodeid CSINode
