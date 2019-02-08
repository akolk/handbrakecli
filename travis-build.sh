#!/bin/bash
set -e

# Prepare qemu
docker run --rm --privileged multiarch/qemu-user-static:register --reset

# Get qemu package
echo "Getting qemu package for $ARCH"
mkdir tmp
pushd tmp
# Fake qemu for amd64 builds to avoid breaking COPY in Dockerfile
if [ $ARCH == 'amd64' ]; then
    touch qemu-"$ARCH"-static
else
    curl -L -o qemu-"$ARCH"-static.tar.gz https://github.com/multiarch/qemu-user-static/releases/download/"$QEMU_VERSION"/qemu-"$ARCH"-static.tar.gz
    tar xzf qemu-"$ARCH"-static.tar.gz
fi
popd

# Build image
VER=`echo $VERSION |sed s/^v//g`
docker build --build-arg handbrakecli_version="$VER" --build-arg target=$TARGET --build-arg arch=$ARCH --build-arg tag=$TAG --build-arg handbrakecli_arch="$HANDBRAKECLI_ARCH" -t "$IMAGE":"$VERSION"-"$TAG" .

# Test image
# docker run --rm "$IMAGE":"$VERSION"-"$TAG" uname -a
