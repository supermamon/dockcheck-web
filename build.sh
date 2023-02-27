#!/usr/bin/env bash

set -e

GITHUB_USER=supermamon

echo "* logging in"
echo $CR_PAT | docker login ghcr.io -u $GITHUB_USER --password-stdin

echo "* building images"
docker build --platform linux/amd64 -t ghcr.io/$GITHUB_USER/dockcheck-web:amd64 --build-arg ARCH=linux/amd64 .
docker build --platform linux/arm64/v8 -t ghcr.io/$GITHUB_USER/dockcheck-web:arm64v8 --build-arg ARCH=linux/arm64 .

echo "* pushing images"
docker push ghcr.io/$GITHUB_USER/dockcheck-web:amd64 
docker push ghcr.io/$GITHUB_USER/dockcheck-web:arm64v8

echo "* creating manifest"
docker manifest create \
ghcr.io/$GITHUB_USER/dockcheck-web:latest \
--amend ghcr.io/$GITHUB_USER/dockcheck-web:amd64 \
--amend ghcr.io/$GITHUB_USER/dockcheck-web:arm64v8

echo "* pushing manifest"
docker manifest push --purge ghcr.io/$GITHUB_USER/dockcheck-web:latest

