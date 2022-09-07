#!/bin/bash
docker login -u "$DOCKER_USERNAME" -p "$DOCKER_PASSWORD"
docker buildx create --use
# build and push
docker buildx build --push --build-arg OCAML_VERSION=$OCAML_VERSION --build-arg UNISON_VERSION=$UNISON_VERSION --platform linux/arm64/v8,linux/amd64 --tag eugenmayer/unison:$UNISON_VERSION-$OCAML_VERSION .
