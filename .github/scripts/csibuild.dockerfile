FROM golang:1.15 as csi-builder
RUN mkdir -p /go/src/gluster/
WORKDIR /go/src/gluster/
ADD ["driver/go.mod", "driver/go.sum", "./"]
RUN go mod download
ADD driver/ ./
RUN go build
