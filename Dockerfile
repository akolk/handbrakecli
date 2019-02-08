ARG target=arm64v8
FROM $target/debian:9.3-slim

ARG arch=aarch64
ENV ARCH=$arch

ARG handbrakecli_version
ENV VERSION=$handbrakecli_version

ARG handbrakecli_arch=arm64
ENV HANDBRAKE_ARCH=$handbrakecli_arch

ARG tag
ENV TAG=$tag

ARG DEBIAN_FRONTEND=noninteractive

# Trick docker build in case qemu binary is not in dir.
COPY .blank tmp/qemu-$ARCH-static* /usr/bin/

RUN apt-get update && \
    apt-get install -y software-properties-common && \
    apt-get install -y handbrake-cli_${VERSION}+ds1-1_${HANDBRAKE_ARCH}.deb

ENTRYPOINT ["HandBrakeCLI"]
