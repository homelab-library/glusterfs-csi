FROM golang:1.15 as builder
RUN curl -sL "https://github.com/kubernetes-csi/node-driver-registrar/archive/v2.0.1.tar.gz" > /registrar.tar.gz && \
    mkdir -p /go/src/csi-node-driver-registrar/
RUN tar -xvzf /registrar.tar.gz -C /go/src/csi-node-driver-registrar/ --strip-components=1
RUN cd /go/src/csi-node-driver-registrar && make

FROM gcr.io/distroless/static:latest
LABEL maintainers="Kubernetes Authors"
LABEL description="CSI Node driver registrar"
COPY --from=builder /go/src/csi-node-driver-registrar/bin/csi-node-driver-registrar /csi-node-driver-registrar
ENTRYPOINT ["/csi-node-driver-registrar"]
