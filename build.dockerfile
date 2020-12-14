FROM golang:1.15 as csi-builder
RUN apt-get update && apt-get install -y xz-utils
ARG GFS_VERSION="v8.3r2"
RUN curl -sL "https://github.com/homelab-library/glusterfs-csi/releases/download/gfs-${GFS_VERSION}/glusterfs-amd64.tar.xz" > /gfs.tar.xz
RUN mkdir -p /dist
RUN tar -xvJ -f /gfs.tar.xz -C /
RUN cp -r /dist/* /
RUN cp /usr/local/lib/* /usr/lib/ || true

RUN mkdir -p /go/src/gluster/
WORKDIR /go/src/gluster/
ADD ["driver/go.mod", "driver/go.sum", "./"]
RUN go mod download
