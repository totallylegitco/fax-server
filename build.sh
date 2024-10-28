#!/bin/bash
set -ex

IMAGE_BASE=holdenk/fax-server
VERSION=0.0.2
DOCKER_CMD=${DOCKER_CMD:"--push"}
# Install hylafax server so we can copy the configs over.
# This is a terrible hack but eh yolo
sudo apt-get install -y hylafax-server
sudo tar -cf hylafax-config.tar /etc/hylafax/
sync
sleep 1
IMAGE="${IMAGE_BASE}:${VERSION}"
VOIP_IMAGE="${IMAGE_BASE}-voip:${VERSION}"
docker pull "${IMAGE}" || docker buildx build --platform=linux/amd64,linux/arm64 -t "${IMAGE}" . "${DOCKER_CMD}"
if [ -n "${SW_TOKEN}" ]; then
  docker pull "${VOIP_IMAGE}" || docker buildx build --platform=linux/amd64,linux/arm64 -t "${VOIP_IMAGE}" . -f Dockerfile-voip --build-arg base="${IMAGE}" --build-arg SW_TOKEN="${SW_TOKEN}" "--${DOCKER_CMD}"
else
  echo "Skipping building VOIP image, missing tokane for freeswitch."
fi
