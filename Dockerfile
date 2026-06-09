FROM golang:1.26-alpine AS builder
ARG TARGETOS
ARG TARGETARCH
ARG TARGETVARIANT

RUN apk add --no-cache git

WORKDIR /build
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 GOOS="${TARGETOS}" GOARCH="${TARGETARCH}" GOARM="${TARGETVARIANT#v}" \
    go build -trimpath -ldflags '-w -s' -o srun-login ./cmd

FROM alpine:latest

COPY --from=builder /build/srun-login /bin/srun
COPY resources/autologin.sh /opt/autologin.sh

RUN chmod +x /bin/srun /opt/autologin.sh

ENTRYPOINT ["/opt/autologin.sh", "/var/log/hdunet.log", "/var/log/hdulogin.log"]
