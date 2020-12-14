FROM buildpack-deps:buster as builder
RUN mkdir -p /dist

ARG TARGETPLATFORM
ARG CSI_VERSION="v0.0.1-alpha"
ARG GFS_VERSION="v8.3r2"
RUN TEMPARCH="${TARGETPLATFORM#*\/}" && \
    echo "${TEMPARCH%\/*}" > /arch
RUN curl -sL "https://github.com/homelab-library/glusterfs-csi/releases/download/csi-${CSI_VERSION}/gluster-csi-$(cat /arch).tar.xz" > /csi.tar.xz
RUN curl -sL "https://github.com/homelab-library/glusterfs-csi/releases/download/gfs-${GFS_VERSION}/glusterfs-$(cat /arch).tar.xz" > /gfs.tar.xz

RUN mkdir -p /dist/usr/bin
RUN tar -xvJ -C /dist/usr/bin -f /csi.tar.xz
RUN tar -xvJ -C / -f /gfs.tar.xz

FROM debian:buster-slim
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib

RUN apt-get update && apt-get install -y attr libtirpc3 fuse \
    libfuse2 libacl1 libaio1 libxml2 liburcu6 && \
    rm -rf /var/lib/apt/lists/*
COPY --from=builder /dist/ /

ENTRYPOINT [ "/usr/bin/gluster-csi" ]
