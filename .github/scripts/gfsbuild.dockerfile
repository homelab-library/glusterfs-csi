FROM buildpack-deps:buster as gfs-builder
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y make automake autoconf libtool flex bison \
    pkg-config libssl-dev libxml2-dev python-dev libaio-dev \
    libibverbs-dev librdmacm-dev libreadline-dev liblvm2-dev \
    libglib2.0-dev liburcu-dev libcmocka-dev libsqlite3-dev \
    libacl1-dev ca-certificates curl libgssglue-dev libssl-dev \
    libnfs-dev doxygen cmake gcc git cmake \
    libkrb5-dev gss-ntlmssp-dev libgss-dev libfuse-dev \
    libfuse3-dev librpcsecgss-dev libnfsidmap-dev libnfs-dev

RUN mkdir -p /build/gfs && \
    curl -sL "https://github.com/gluster/glusterfs/archive/v8.3.tar.gz" > /build/gfs/glusterfs.tar.gz && \
    cd /build/gfs && tar -xvzf glusterfs.tar.gz --strip-components=1 && rm glusterfs.tar.gz

WORKDIR /build
RUN cd gfs && ./autogen.sh && \
    mkdir -p /dist && ./configure && \
    make && \
    DESTDIR=/dist make install

RUN mv /dist/var/run /dist/run
