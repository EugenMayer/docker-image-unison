#!/bin/bash
echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
echo "creating manifests for different arches"
docker manifest create eugenmayer/unison:$UNISON_VERSION-$OCAML_VERSION eugenmayer/unison:$UNISON_VERSION-$OCAML_VERSION-AMD64 eugenmayer/unison:$UNISON_VERSION-$OCAML_VERSION-ARM64
docker manifest push eugenmayer/unison:$UNISON_VERSION-$OCAML_VERSION

echo "deploying on docker hub"
docker push eugenmayer/unison
